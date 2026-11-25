# Project handover

## Current state
- Repository noeht-code/dolevi-konsult; development branch develop/1.10.0; main must not be modified by bridge.
- TimeTracker WP-01 automated history tests passed; installed iPhone acceptance and authentic legacy backup outstanding. No WP-02 or application changes authorized before WP-01 verification.
- Bridge v0.4.0 positive PR pilot passed (issue 4, PR 5 closed without merge). v0.4.2 local component suite passed; see tools/bridge/VERIFICATION_V042.md.
- NEG-01/02 passed on Windows; NEG-03/04 and sequential NEG-05 passed as components; NEG-06 cleanup component passed. Concurrent claim test newly added, not executed. Full runner failure reporting/no-publication and positive regression pending.
- Next: run Test-BridgeConcurrent.ps1; then real runner integration with stale approved base (safe failure before Codex), verify FAIL/BASE, published=false, cleanup=true, repeat blocked. Then positive v0.4.2 regression. Only then enable v0.5 pilot.
## Environment and decisions
- Windows PowerShell, Git, gh and Codex CLI authenticated via ChatGPT. Explicit windows.sandbox elevated with workspace-write required. No additional paid services or API keys authorized.
- Single PC/user; persistent local claim files; no automatic retry or merge. Old runner versions must not be used for new tasks. Public repository: no secrets or real customer data.
- User approved v0.5 development after verification; proposed polling 30 seconds, one task at a time. Not implemented or enabled yet.
- Swedish conversation, English documentation. Truthful evidence, distinguish implementation from verification. User says 'Fortsätt' to resume concrete work. No background execution between turns. Warn when context reliability degrades; exact remaining context unavailable.

## Latest evidence
2026-11-25: concurrent claim test PASS on Windows. Issue 7 stale-base integration returned FAIL/BASE, published=false, pr=null, cleanup=true: https://github.com/noeht-code/dolevi-konsult/issues/7#issuecomment-7176588540. Repeat blocked by persistent claim. Positive v0.4.2 regression is next. Failure after Codex and full isolation remain unverified. This update supersedes earlier pending statements about concurrent claims and stale-base failure.
