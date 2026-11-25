param([switch]$Once)
$ErrorActionPreference='Stop'
$repo='noeht-code/dolevi-konsult'
$queue=Join-Path $env:LOCALAPPDATA 'DoleviBridge\approvals'
New-Item -ItemType Directory -Path $queue -Force | Out-Null
do{
 foreach($file in @(Get-ChildItem -LiteralPath $queue -Filter '*.json' -File | Sort-Object Name)){
  if($file.Name -cnotmatch '^([1-9][0-9]*)\.json$'){continue}
  $issue=[int]$Matches[1]
  $running=$file.FullName+'.consumed'
  try{[IO.File]::Move($file.FullName,$running)}catch{continue}
  try{
   $a=Get-Content -LiteralPath $running -Raw | ConvertFrom-Json
   if($a.issue -ne $issue -or $a.hash -cnotmatch '^[a-f0-9]{64}$'){throw 'Invalid approval'}
   & powershell.exe -NoProfile -File (Join-Path $PSScriptRoot 'Invoke-DoleviBridge-v042.ps1') -Issue $issue -ApprovalSha256 $a.hash
   if($LASTEXITCODE -ne 0){throw 'Runner failed; manual review required'}
  }catch{Write-Warning ("Issue "+$issue+": "+$_.Exception.Message)}
 }
 if(-not $Once){Start-Sleep -Seconds 30}
}while(-not $Once)
