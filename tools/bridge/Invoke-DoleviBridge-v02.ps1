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
if($q.schema -cne 'dolevi-task-1' -or $q.mode -cne 'read-only' -or $q.taskId -cne "BRIDGE-$Issue" -or $q.expected -cnotmatch '^[A-Z0-9 -]{1,80}$'){throw 'Invalid task'}
foreach($field in @('objective','requirements','scope','restrictions','acceptance','tests','deliverables')){if($q.$field -isnot [string] -or [string]::IsNullOrWhiteSpace($q.$field)){throw "Missing $field"}}
$root=Join-Path ([IO.Path]::GetTempPath()) ('dolevi-bridge-'+[guid]::NewGuid())
New-Item -ItemType Directory $root | Out-Null
try{
 $prompt="Read-only task. No shell commands, network, credentials or file changes. Return only the expected response. Task JSON: "+$t.body
 $events=$prompt | codex exec --cd $root --skip-git-repo-check --sandbox read-only --ignore-user-config --ephemeral --json -
 if($LASTEXITCODE -ne 0){throw 'Codex failed'}
 $p=@($events | ForEach-Object {$_ | ConvertFrom-Json})
 $m=@($p | Where-Object {$_.type -eq 'item.completed' -and $_.item.type -eq 'agent_message'})
 $done=@($p | Where-Object {$_.type -eq 'turn.completed'})
 $bad=@($p | Where-Object {$_.type -match 'failed|error' -or ($_.type -like 'item.*' -and $_.item.type -notin @('agent_message','reasoning'))})
 if($m.Count -ne 1 -or $done.Count -ne 1 -or $bad.Count -ne 0 -or $m[0].item.text.Trim() -cne $q.expected){throw 'Result validation failed'}
 $result=[ordered]@{schema='dolevi-result-1';version='0.2.0';taskId=$q.taskId;approvalSha256=$hash;status='PASS';check='exact-response'}
 $result | ConvertTo-Json -Compress | gh issue comment $Issue --repo $repo --body-file -
 if($LASTEXITCODE -ne 0){throw 'Reporting failed'}
 Write-Host 'Bridge v0.2.0 PASS'
}finally{Remove-Item -LiteralPath $root -Recurse -Force}
