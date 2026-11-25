$ErrorActionPreference='Stop'
$lib=Join-Path $PSScriptRoot 'BridgeChecks.ps1'
. $lib
$root=Join-Path ([IO.Path]::GetTempPath()) ('dolevi-race-'+[guid]::NewGuid())
New-Item -ItemType Directory $root | Out-Null
$jobs=@()
try{
 $claim=Join-Path $root 'race.claim'
 $gate=Join-Path $root 'start'
 foreach($i in 1..2){
  $jobs+=Start-Job -ArgumentList $lib,$claim,$gate -ScriptBlock {
   param($lib,$claim,$gate)
   $ErrorActionPreference='Stop'
   . $lib
   $deadline=[DateTime]::UtcNow.AddSeconds(30)
   while(-not (Test-Path -LiteralPath $gate)){
    if([DateTime]::UtcNow -gt $deadline){throw 'Gate timeout'}
    Start-Sleep -Milliseconds 20
   }
   try{New-BridgeClaim $claim 'race-test';'WON'}catch{
    if($_.Exception.Message -cne 'Task already claimed or registry unavailable; manual review required'){throw}
    'BLOCKED'
   }
  }
 }
 [IO.File]::WriteAllText($gate,'start')
 $null=Wait-Job -Job $jobs -Timeout 60
 if(@($jobs | Where-Object {$_.State -ne 'Completed'}).Count -ne 0){throw 'Job failed or timed out'}
 $results=@($jobs | Receive-Job -ErrorAction Stop)
 if($results.Count -ne 2 -or @($results | Where-Object {$_ -ceq 'WON'}).Count -ne 1 -or @($results | Where-Object {$_ -ceq 'BLOCKED'}).Count -ne 1){throw 'Race result invalid'}
 if([IO.File]::ReadAllText($claim) -cne 'race-test'){throw 'Claim content invalid'}
 Write-Host 'NEG-05 concurrent processes PASS'
}finally{
 foreach($job in $jobs){Remove-Job -Job $job -Force}
 Remove-BridgeWorkspace $root
}
