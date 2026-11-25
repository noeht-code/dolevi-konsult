$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'BridgeChecks.ps1')
function Expect-Rejection($name,$expected,[scriptblock]$action){
 $actual=$null
 try{& $action}catch{$actual=$_.Exception.Message}
 if($actual -cne $expected){throw "$name unexpected result: $actual"}
 Write-Host "$name PASS"
}
$root=Join-Path ([IO.Path]::GetTempPath()) ('dolevi-test-'+[guid]::NewGuid())
New-Item -ItemType Directory $root | Out-Null
try{
 $work=Join-Path $root 'repo'
 git init -q $work
 if($LASTEXITCODE -ne 0){throw 'git init failed'}
 git -C $work -c user.name=Test -c user.email=test@example.invalid commit --allow-empty -qm baseline
 if($LASTEXITCODE -ne 0){throw 'git commit failed'}
 $base=git -C $work rev-parse HEAD
 $q=[pscustomobject]@{base=$base;scope='bridge-pr-smoke.txt';fileContent='DOLEVI BRIDGE PR TEST'}
 $file=Join-Path $work $q.scope
 [IO.File]::WriteAllText($file,$q.fileContent)
 Assert-BridgeChanges $work $q
 Write-Host 'Positive scope control PASS'
 $extra=Join-Path $work 'extra.txt'
 [IO.File]::WriteAllText($extra,'unexpected')
 Expect-Rejection 'NEG-03' 'Unexpected changes' {Assert-BridgeChanges $work $q}
 Remove-Item -LiteralPath $extra
 [IO.File]::WriteAllText($file,'wrong')
 Expect-Rejection 'NEG-04' 'Content mismatch' {Assert-BridgeChanges $work $q}
 $claim=Join-Path $root 'test.claim'
 New-BridgeClaim $claim 'test-hash'
 Expect-Rejection 'NEG-05' 'Task already claimed or registry unavailable; manual review required' {New-BridgeClaim $claim 'test-hash'}
 $failure=Join-Path $root 'failure'
 New-Item -ItemType Directory $failure | Out-Null
 try{throw 'Simulated failure'}catch{if($_.Exception.Message -cne 'Simulated failure'){throw}}finally{Remove-BridgeWorkspace $failure}
 if(Test-Path $failure){throw 'Cleanup failed'}
 Write-Host 'NEG-06 cleanup component PASS'
}finally{Remove-BridgeWorkspace $root}
Write-Host 'LOCAL COMPONENT TESTS PASS'
