param([Parameter(Mandatory=$true)][int]$Issue,[Parameter(Mandatory=$true)][string]$ApprovalSha256)
$ErrorActionPreference='Stop'
$repo='noeht-code/dolevi-konsult'
$baseBranch='develop/1.10.0'
$raw=gh issue view $Issue --repo $repo --json body,author,state
if($LASTEXITCODE -ne 0){throw 'Issue read failed'}
$t=$raw | ConvertFrom-Json
if($t.author.login -cne 'noeht-code' -or $t.state -ne 'OPEN'){throw 'Unauthorized task'}
$sha=[Security.Cryptography.SHA256]::Create()
try{$hash=[BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($t.body))).Replace('-','').ToLowerInvariant()}finally{$sha.Dispose()}
if($hash -cne $ApprovalSha256){throw 'Approval mismatch'}
$q=$t.body | ConvertFrom-Json
if($q.schema -cne 'dolevi-task-1' -or $q.taskId -cne "BRIDGE-$Issue" -or $q.mode -cne 'pr-pilot' -or $q.base -cnotmatch '^[a-f0-9]{40}$' -or $q.scope -cne 'bridge-pr-smoke.txt' -or $q.fileContent -cne 'DOLEVI BRIDGE PR TEST'){throw 'Unsupported pilot'}
$registry=Join-Path $env:LOCALAPPDATA 'DoleviBridge\claims'
New-Item -ItemType Directory -Path $registry -Force | Out-Null
$claim=Join-Path $registry "noeht-code-dolevi-konsult-$Issue.claim"
try{
 $stream=[IO.File]::Open($claim,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
 try{$bytes=[Text.Encoding]::UTF8.GetBytes($hash);$stream.Write($bytes,0,$bytes.Length);$stream.Flush()}finally{$stream.Dispose()}
}catch{throw 'Task already claimed or registry unavailable; manual review required'}
$root=Join-Path ([IO.Path]::GetTempPath()) ('dolevi-bridge-'+[guid]::NewGuid())
$branch="bridge/pilot-$Issue-"+[guid]::NewGuid().ToString('N')
$stage='CLONE'
$pr=$null
$published=$false
$status='FAIL'
$cleaned=$false
try{
 git clone --single-branch --branch $baseBranch "https://github.com/$repo.git" $root
 if($LASTEXITCODE -ne 0){throw 'Clone failed'}
 $stage='BASE'
 $head=git -C $root rev-parse HEAD
 if($LASTEXITCODE -ne 0 -or $head -cne $q.base){throw 'Approved base is not current'}
 git -C $root checkout -b $branch
 if($LASTEXITCODE -ne 0){throw 'Branch failed'}
 if(Test-Path (Join-Path $root $q.scope)){throw 'Pilot file exists'}
 $stage='CODEX'
 $prompt='Use apply_patch to create only bridge-pr-smoke.txt containing exactly DOLEVI BRIDGE PR TEST (optional final newline). No shell commands, other edits, commits, pushes, credentials or network. Return BRIDGE PR PASS on success.'
 $events=$prompt | codex exec --cd $root --sandbox workspace-write --ignore-user-config --ephemeral -c 'windows.sandbox="elevated"' --json -
 if($LASTEXITCODE -ne 0){throw 'Codex failed'}
 $p=@($events | ForEach-Object {$_ | ConvertFrom-Json})
 $m=@($p | Where-Object {$_.type -eq 'item.completed' -and $_.item.type -eq 'agent_message'})
 if($m.Count -lt 1 -or $m[-1].item.text.Trim() -cne 'BRIDGE PR PASS' -or @($p | Where-Object {$_.type -eq 'turn.completed'}).Count -ne 1 -or @($p | Where-Object {$_.type -match 'failed|error'}).Count -ne 0){throw 'Codex result failed'}
 $stage='TEST'
 $head=git -C $root rev-parse HEAD
 if($LASTEXITCODE -ne 0 -or $head -cne $q.base){throw 'HEAD changed'}
 $changes=@(git -C $root status --porcelain --untracked-files=all)
 if($LASTEXITCODE -ne 0 -or $changes.Count -ne 1 -or $changes[0] -cne '?? bridge-pr-smoke.txt'){throw 'Unexpected changes'}
 $file=Get-Item -LiteralPath (Join-Path $root $q.scope)
 if($file.Attributes -band [IO.FileAttributes]::ReparsePoint){throw 'Unexpected link'}
 if([IO.File]::ReadAllText($file.FullName).TrimEnd([char[]]"`r`n") -cne $q.fileContent){throw 'Content mismatch'}
 $stage='COMMIT'
 git -C $root add -- bridge-pr-smoke.txt
 if($LASTEXITCODE -ne 0){throw 'Add failed'}
 git -C $root -c user.name='Dolevi Bridge' -c user.email='bridge@users.noreply.github.com' commit -m 'Bridge v0.4 isolated PR pilot'
 if($LASTEXITCODE -ne 0){throw 'Commit failed'}
 $diff=@(git -C $root diff --name-only $q.base HEAD)
 if($LASTEXITCODE -ne 0 -or $diff.Count -ne 1 -or $diff[0] -cne $q.scope){throw 'Commit scope mismatch'}
 $parent=git -C $root rev-parse HEAD^
 if($LASTEXITCODE -ne 0 -or $parent -cne $q.base){throw 'Parent mismatch'}
 $stage='PUSH'
 git -C $root push "https://github.com/$repo.git" "HEAD:refs/heads/$branch"
 if($LASTEXITCODE -ne 0){throw 'Push failed'}
 $published=$true
 $stage='PR'
 $pr=gh pr create --repo $repo --base $baseBranch --head $branch --title "Bridge v0.4 pilot $Issue" --body 'Disposable pilot only. Independent file and Git checks passed. Do not merge.' --draft
 if($LASTEXITCODE -ne 0){throw 'PR failed'}
 $status='PASS'
 $stage='COMPLETE'
}finally{
 if(Test-Path -LiteralPath $root){try{Remove-Item -LiteralPath $root -Recurse -Force}catch{$status='FAIL';$stage='CLEANUP'}}
 $cleaned=-not (Test-Path -LiteralPath $root)
 $result=[ordered]@{schema='dolevi-result-1';version='0.4.1';taskId=$q.taskId;approvalSha256=$hash;status=$status;stage=$stage;branch=$branch;published=$published;pr=$pr;cleanup=$cleaned}
 $result | ConvertTo-Json -Depth 5 -Compress | gh issue comment $Issue --repo $repo --body-file -
 if($LASTEXITCODE -ne 0){throw 'Reporting failed'}
}
if($status -ne 'PASS'){throw 'Pilot failed'}
