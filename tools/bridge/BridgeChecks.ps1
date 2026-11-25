function New-BridgeClaim($claim,$hash){
try{
 $stream=[IO.File]::Open($claim,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
 try{$bytes=[Text.Encoding]::UTF8.GetBytes($hash);$stream.Write($bytes,0,$bytes.Length);$stream.Flush()}finally{$stream.Dispose()}
}catch{throw 'Task already claimed or registry unavailable; manual review required'}
}
function Assert-BridgeChanges($root,$q){
 $head=git -C $root rev-parse HEAD
 if($LASTEXITCODE -ne 0 -or $head -cne $q.base){throw 'HEAD changed'}
 $changes=@(git -C $root status --porcelain --untracked-files=all)
 if($LASTEXITCODE -ne 0 -or $changes.Count -ne 1 -or $changes[0] -cne '?? bridge-pr-smoke.txt'){throw 'Unexpected changes'}
 $file=Get-Item -LiteralPath (Join-Path $root $q.scope)
 if($file.Attributes -band [IO.FileAttributes]::ReparsePoint){throw 'Unexpected link'}
 if([IO.File]::ReadAllText($file.FullName).TrimEnd([char[]]"`r`n") -cne $q.fileContent){throw 'Content mismatch'}
}
function Remove-BridgeWorkspace($root){
 if(Test-Path -LiteralPath $root){Remove-Item -LiteralPath $root -Recurse -Force}
 if(Test-Path -LiteralPath $root){throw 'Cleanup failed'}
}
