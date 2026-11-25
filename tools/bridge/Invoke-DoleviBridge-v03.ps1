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
$diagnostic=[ordered]@{}
$code='E300'
try{
 git -C $root checkout --detach $q.base
 if($LASTEXITCODE -ne 0){throw 'Checkout failed'}
 if(Test-Path (Join-Path $root 'bridge-smoke.txt')){throw 'Test file already exists'}
 $prompt='Use only the apply_patch file editing tool to create bridge-smoke.txt containing exactly DOLEVI BRIDGE WRITE TEST (optional final newline). Do not invoke shell commands, inspect Git status, read back the file, modify other files, commit, push, access credentials or network. The caller independently checks Git and file contents. If editing succeeds return BRIDGE WRITE PASS; otherwise return BRIDGE WRITE FAIL. Approved task JSON: '+$t.body
 $events=$prompt | codex exec --cd $root --sandbox workspace-write --ignore-user-config --ephemeral -c 'windows.sandbox="elevated"' --json -
 if($LASTEXITCODE -ne 0){throw 'Codex failed'}
 $p=@($events | ForEach-Object {$_ | ConvertFrom-Json})
 $m=@($p | Where-Object {$_.type -eq 'item.completed' -and $_.item.type -eq 'agent_message'})
 $done=@($p | Where-Object {$_.type -eq 'turn.completed'})
 $bad=@($p | Where-Object {$_.type -match 'failed|error'})
 $diagnostic.messageCount=$m.Count
 $diagnostic.completedCount=$done.Count
 $diagnostic.errorCount=$bad.Count
 $diagnostic.patchCount=@($p | Where-Object {$_.type -eq 'item.completed' -and $_.item.type -eq 'file_change'}).Count
 $diagnostic.fileExists=Test-Path -LiteralPath (Join-Path $root 'bridge-smoke.txt')
 $diagnostic.expectedResponse=($m.Count -gt 0 -and $m[-1].item.text.Trim() -ceq $q.expected)
 if($m.Count -lt 1){$code='E301';throw 'No agent response'}
 if($bad.Count -ne 0){$code='E304';throw 'Codex error event'}
 if($done.Count -ne 1){$code='E303';throw 'Unexpected completion count'}
 if(-not $diagnostic.expectedResponse){$code='E302';throw 'Unexpected agent response'}
 $head=git -C $root rev-parse HEAD
 if($LASTEXITCODE -ne 0 -or $head -cne $q.base){$code='E305';throw 'HEAD changed'}
 $changes=@(git -C $root status --porcelain --untracked-files=all)
 if($LASTEXITCODE -ne 0 -or $changes.Count -ne 1 -or $changes[0] -cne '?? bridge-smoke.txt'){$code='E306';throw 'Unexpected changes'}
 $file=Get-Item -LiteralPath (Join-Path $root 'bridge-smoke.txt')
 if($file.Attributes -band [IO.FileAttributes]::ReparsePoint){$code='E306';throw 'Unexpected link'}
 if([IO.File]::ReadAllText($file.FullName).TrimEnd([char[]]"`r`n") -cne $q.fileContent){$code='E307';throw 'File content mismatch'}
 $result=[ordered]@{schema='dolevi-result-1';version='0.3.0';taskId=$q.taskId;approvalSha256=$hash;status='PASS';check='isolated-write';base=$q.base;file='bridge-smoke.txt'}
 $result | ConvertTo-Json -Depth 5 -Compress | gh issue comment $Issue --repo $repo --body-file -
 if($LASTEXITCODE -ne 0){throw 'Reporting failed'}
 Write-Host 'Bridge v0.3.0 PASS'
}catch{
 $failure=[ordered]@{schema='dolevi-result-1';version='0.3.0';taskId=$q.taskId;approvalSha256=$hash;status='FAIL';check='isolated-write';reason=$code;diagnostic=$diagnostic}
 $failure | ConvertTo-Json -Compress | gh issue comment $Issue --repo $repo --body-file -
 throw
}finally{Remove-Item -LiteralPath $root -Recurse -Force}
