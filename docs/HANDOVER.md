# Project handover — 2026-11-25

## Current state
- Repository: noeht-code/dolevi-konsult; branch develop/1.10.0. Main unchanged by bridge pilots.
- TimeTracker baseline 1.9.7. WP-01 automated historical invoice tests passed (Actions run 45686910532); installed iPhone acceptance and authentic legacy backup outstanding. WP-02 must not start before WP-01 verification. No application code changed during bridge work.
- Development Bridge v0.5.0: all eight pilot acceptance criteria passed on Windows. Continuous worker stopped (console returned to prompt). PR 14 inspected and closed without merge; issue 13 closed. See tools/bridge/POLLING_PILOT.md and VERIFICATION_V042.md.
- Next proposed milestone v0.6.0: controlled correction loop, initially disposable fixtures only. Define bounded attempts, independent tests, scope validation, explicit authorization for retries, failure reporting, no automatic merge. Existing v0.5 does not authorize retry; do not silently change that rule. No implementation yet.
- New chat recommended now. Read this file, docs/DEVELOPMENT_WORKFLOW.md, tools/bridge/POLLING_PILOT.md and actual current scripts before editing. GitHub is source of truth; check current branch head.

## Evidence
- v0.4.2: issue 7 stale-base rejection, cleanup reported, duplicate blocked; concurrent claim test passed; issue 8 positive regression, PR 9 closed unmerged.
- v0.5: issue 10 positive Once pilot, PR 11 closed unmerged; issue 12 modified approval rejected before Codex and consumed; issue 13 continuous pickup and exclusive worker lock verified, PR 14 only bridge-pr-smoke.txt with DOLEVI BRIDGE PR TEST.
- Report: https://github.com/noeht-code/dolevi-konsult/issues/13#issuecomment-7176926836
- Cleanup is runner-reported. Long-duration unattended operation, comprehensive isolation and post-Codex failure paths remain unverified. Test branches retained.

## Environment and operating rules
- Windows local clone: $HOME\Dolevi-TimeTracker-Dev; Git, gh, Codex CLI authenticated using ChatGPT. Explicit windows.sandbox elevated for workspace-write. No additional paid services or paid API authorized; quota not independently verified.
- Start-DoleviBridge-v05.ps1 polls local approval queue every 30 seconds; Approve-BridgeTask.ps1 displays task and requires JA. Runner v042 re-fetches GitHub body and validates hash and base. Shared GitHub identity cannot establish human approval; local approval is required. Queue and claims persist under LOCALAPPDATA\DoleviBridge. Same-user software is not isolated by queue. Single PC/user; no automatic retry, merge, update or arbitrary app tasks. Older scripts must not be used to bypass controls.
- Public repository: no real customer data, secrets or backups. iPhone installed PWA only; local storage and backup/restore; no sync. Test data discarded before production.
- User product owner; assistant technical lead; Codex implementation/testing. Swedish conversation, English documentation; factual evidence, no inventions. User says Fortsätt to resume concrete work; stop for local execution or decisions. No background work between chat turns. Keep documentation current and warn when context reliability degrades.
