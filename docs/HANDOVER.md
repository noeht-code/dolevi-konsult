# Project handover

## Current status (2026-11-25)
- Repository noeht-code/dolevi-konsult; branch develop/1.10.0. Main unchanged.
- TimeTracker WP-01 automated history tests passed; installed iPhone acceptance and authentic legacy backup outstanding. WP-02 not authorized before WP-01 verification.
- Bridge v0.4.2 pilot gate passed: issue 7 negative stale-base and duplicate prevention; concurrent claim test passed; issue 8 positive regression, PR 9 inspected and closed without merge. See VERIFICATION_V042.md.
- v0.5 polling pilot implemented in 6149dca; worker lock and empty queue diagnostics added in current revision. Not executed yet.
- Next: Windows empty queue test, locally approve positive pilot, run worker Once, inspect PR and report, repeat Once; then modified-body negative test and continuous polling/worker lock verification. No unattended operation before verification.
## Decisions and constraints
- Windows PowerShell, Git, gh, Codex CLI via ChatGPT; explicit windows.sandbox elevated for workspace-write. No paid API or additional paid services authorized.
- Local approval required; shared GitHub identity cannot distinguish human approval. Persistent claims and consumed queue files; no automatic retry or merge. Local queue not a security boundary against same-user software. No automatic update.
- Public repo: no real customer data, secrets or backups. Pilot only; post-Codex failure paths and comprehensive isolation not verified.
- Swedish conversation, English documentation. Truthful evidence. User says Fortsätt to resume concrete work. No background execution between turns. Exact remaining context unavailable; recommend planned chat transition after v0.5 verification or earlier if reliability degrades.

## Windows positive polling evidence
2026-11-25: empty queue, local approval, Once execution and subsequent empty queue passed. Issue 10 result PASS/COMPLETE, cleanup=true (reported), PR 11 independently inspected, only expected test file, closed without merge. AUT-0501 through 0505 passed for Once pilot. Next: approve issue 12, then modify its body before execution; verify rejection and consumed queue. Continuous polling and exclusive worker lock remain unverified. No application edits.
