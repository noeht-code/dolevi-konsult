param([switch]$Once)
$ErrorActionPreference='Stop'
$repo='noeht-code/dolevi-konsult'
$queue=Join-Path $env:LOCALAPPDATA 'DoleviBridge\approvals'
New-Item -ItemType Directory -Path $queue -Force | Out-Null
$lockPath=Join-Path $queue 'worker.lock'
$lock=[IO.File]::Open($lockPath,[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
try{
do{
 $files=@(Get-ChildItem -LiteralPath $queue -Filter '*.json' -File | Sort-Object Name)
 if($files.Count -eq 0){Write-Host 'No pending approvals'}
 foreach($file in $files){
  if($file.Name -cnotmatch '^([1-9][0-9]*)\.json$'){continue}
  $issue=0
  if(-not [int]::TryParse($Matches[1],[ref]$issue)){continue}
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
}finally{$lock.Dispose()}

