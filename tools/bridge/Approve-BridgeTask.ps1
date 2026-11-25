param([Parameter(Mandatory=$true)][int]$Issue)
$ErrorActionPreference='Stop'
if($Issue -le 0){throw 'Invalid issue'}
$raw=gh issue view $Issue --repo noeht-code/dolevi-konsult --json body,author,state
if($LASTEXITCODE -ne 0){throw 'Issue read failed'}
$t=$raw | ConvertFrom-Json
if($t.author.login -cne 'noeht-code' -or $t.state -ne 'OPEN'){throw 'Unauthorized task'}
$q=$t.body | ConvertFrom-Json
if($q.schema -cne 'dolevi-task-1' -or $q.taskId -cne "BRIDGE-$Issue" -or $q.mode -cne 'pr-pilot' -or $q.base -cnotmatch '^[a-f0-9]{40}$' -or $q.scope -cne 'bridge-pr-smoke.txt' -or $q.fileContent -cne 'DOLEVI BRIDGE PR TEST'){throw 'Unsupported pilot'}
$t.body
if((Read-Host 'Approve this exact pilot task? (JA/NEJ)').Trim() -ne 'JA'){return}
$sha=[Security.Cryptography.SHA256]::Create()
try{$hash=[BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($t.body))).Replace('-','').ToLowerInvariant()}finally{$sha.Dispose()}
$queue=Join-Path $env:LOCALAPPDATA 'DoleviBridge\approvals'
New-Item -ItemType Directory -Path $queue -Force | Out-Null
$target=Join-Path $queue "$Issue.json"
if(Test-Path -LiteralPath ($target+'.consumed')){throw 'Already consumed'}
$temp=Join-Path $queue ([guid]::NewGuid().ToString()+'.tmp')
try{
 [IO.File]::WriteAllText($temp,(@{issue=$Issue;hash=$hash}|ConvertTo-Json -Compress))
 [IO.File]::Move($temp,$target)
}finally{if(Test-Path -LiteralPath $temp){Remove-Item -LiteralPath $temp}}
Write-Host "Approved issue $Issue"
