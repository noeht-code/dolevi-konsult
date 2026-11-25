param([Parameter(Mandatory=$true)][ValidateRange(1,2147483647)][int]$Issue)
$ErrorActionPreference = 'Stop'
$repo = 'noeht-code/dolevi-konsult'
# v0.1.0 deliberately accepts only the known smoke-test task.
if ($Issue -ne 1) { throw 'Only approved smoke test #1 is supported in v0.1.0.' }
$expected = 'Approved integration smoke test only. Return exactly `AUT-04 PASS`. Do not execute shell commands, access credentials, use network tools, modify files, or change the repository. The local PowerShell caller will validate the response and publish a fixed result comment. No TimeTracker implementation work is authorized.'
$raw = gh issue view $Issue --repo $repo --json body,author,state
if ($LASTEXITCODE -ne 0) { throw 'GitHub read failed' }
$task = $raw | ConvertFrom-Json
if ($task.author.login -cne 'noeht-code' -or $task.state -ne 'OPEN' -or $task.body -cne $expected) { throw 'Task validation failed' }
$root = Join-Path ([System.IO.Path]::GetTempPath()) ('dolevi-bridge-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path $root | Out-Null
try {
    $events = $task.body | codex exec --cd $root --skip-git-repo-check --sandbox read-only --ignore-user-config --ephemeral --json -
    if ($LASTEXITCODE -ne 0) { throw 'Codex execution failed' }
    $parsed = @($events | ForEach-Object { $_ | ConvertFrom-Json })
    $messages = @($parsed | Where-Object { $_.type -eq 'item.completed' -and $_.item.type -eq 'agent_message' })
    $completed = @($parsed | Where-Object { $_.type -eq 'turn.completed' })
    $unexpected = @($parsed | Where-Object { $_.type -match 'failed|error' -or ($_.type -like 'item.*' -and $_.item.type -ne 'agent_message' -and $_.item.type -ne 'reasoning') })
    if ($messages.Count -ne 1 -or $messages[0].item.text.Trim() -cne 'AUT-04 PASS' -or $completed.Count -ne 1 -or $unexpected.Count -ne 0) { throw 'Result validation failed' }
    $u = $completed[0].usage
    Write-Host ('Token usage: ' + ($u | ConvertTo-Json -Compress))
    gh issue comment $Issue --repo $repo --body 'Dolevi Development Bridge v0.1.0 PASS - read-only smoke test verified.'
    if ($LASTEXITCODE -ne 0) { throw 'GitHub reporting failed' }
    Write-Host 'Bridge v0.1.0 PASS' -ForegroundColor Green
} finally {
    Remove-Item -LiteralPath $root -Recurse -Force
}
