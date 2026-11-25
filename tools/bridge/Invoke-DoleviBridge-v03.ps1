param([Parameter(Mandatory=$true)][int]$Issue,[Parameter(Mandatory=$true)][string]$ApprovalSha256)
$ErrorActionPreference='Stop'
$repo='noeht-code/dolevi-konsult'
$raw=gh issue view $Issue --repo $repo --json body,author,state
if($LASTEXITCODE -ne 0){throw 'GitHub read failed'}
$t=$raw | ConvertFrom-Json
if($t.author.login -cne 'noeht-code' -or $t.state -ne 'OPEN'){throw 'Unauthorized task'}
$sha=[Security.Cryptography.SHA256]::Create()
try{$hash=[BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($t.body))).Replace('-','').ToLowerInvariant()}finally{$sha.Dispose()}
if($hash -cne $ApprovalSha256){throw 'Task approval hash mismatch'}
$q=$t.body | ConvertFrom-Json
if($q.schema -cne 'dolevi-task-1' -or $q.mode -cne 'workspace-write' -or $q.taskId -cne "BRIDGE-$Issue" -or $q.base -cnotmatch '^[a-f0-9]{40}$' -or $q.expected -cne 'BRIDGE WRITE PASS'){throw 'Invalid task'}
foreach($field in @('objective','requirements','scope','restrictions','acceptance','tests','deliverables')){if($q.$field -isnot [string] -or [string]::IsNullOrWhiteSpace($q.$field)){throw "Missing $field"}}
# First write pilot permits only a disposable test file, never application code.
if($q.scope -cne 'bridge-smoke.txt' -or $q.fileContent -cne 'DOLEVI BRIDGE WRITE TEST'){throw 'Unsupported write scope'}
$root=Join-Path ([IO.Path]::GetTempPath()) ('dolevi-bridge-'+[guid]::NewGuid())
git clone --no-checkout --single-branch --branch develop/1.10.0 "https://github.com/$repo.git" $root
if($LASTEXITCODE -ne 0){throw 'Clone failed'}
try{
 git -C $root checkout --detach $q.base
 if($LASTEXITCODE -ne 0){throw 'Checkout failed'}
 if(Test-Path (Join-Path $root 'bridge-smoke.txt')){throw 'Test file already exists'}
 $prompt='Create only bridge-smoke.txt containing exactly DOLEVI BRIDGE WRITE TEST (optional final newline). Do not modify other files, commit, push, access credentials or network. Return BRIDGE WRITE PASS. Approved task JSON: '+$t.body
 $events=$prompt | codex exec --cd $root --sandbox workspace-write --ignore-user-config --ephemeral --json -
 if($LASTEXITCODE -ne 0){throw 'Codex failed'}
 $p=@($events | ForEach-Object {$_ | ConvertFrom-Json})
 $m=@($p | Where-Object {$_.type -eq 'item.completed' -and $_.item.type -eq 'agent_message'})
 $done=@($p | Where-Object {$_.type -eq 'turn.completed'})
 if($m.Count -lt 1 -or $m[-1].item.text.Trim() -cne $q.expected -or $done.Count -ne 1 -or @($p | Where-Object {$_.type -match 'failed|error'}).Count -ne 0){throw 'Result validation failed'}
 $head=git -C $root rev-parse HEAD
 if($LASTEXITCODE -ne 0 -or $head -cne $q.base){throw 'HEAD changed'}
 $changes=@(git -C $root status --porcelain --untracked-files=all)
 if($LASTEXITCODE -ne 0 -or $changes.Count -ne 1 -or $changes[0] -cne '?? bridge-smoke.txt'){throw 'Unexpected changes'}
 $file=Get-Item -LiteralPath (Join-Path $root 'bridge-smoke.txt')
 if($file.Attributes -band [IO.FileAttributes]::ReparsePoint){throw 'Unexpected link'}
 if([IO.File]::ReadAllText($file.FullName).TrimEnd([char[]]"`r`n") -cne $q.fileContent){throw 'File content mismatch'}
 $result=[ordered]@{schema='dolevi-result-1';version='0.3.0';taskId=$q.taskId;approvalSha256=$hash;status='PASS';check='isolated-write';base=$q.base;file='bridge-smoke.txt'}
 gh issue comment $Issue --repo $repo --body ($result | ConvertTo-Json -Compress)
 if($LASTEXITCODE -ne 0){throw 'Reporting failed'}
 Write-Host 'Bridge v0.3.0 PASS'
}finally{Remove-Item -LiteralPath $root -Recurse -Force}
