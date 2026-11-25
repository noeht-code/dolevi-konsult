# Development workflow — 2026-11-25

Product owner approves requirements and releases. ChatGPT prepares tasks and reviews evidence; Codex implements and tests approved tasks; GitHub is the shared source of truth. No additional paid services without explicit approval. Never publish real customer data, backups or secrets.

## Verified evidence
- AUT-01: Windows Codex CLI 0.172.0 installed; exec help available.
- AUT-02: ChatGPT login and read-only noninteractive smoke test returned AUT-02 PASS. JSONL test returned JSON-TEST PASS with thread/turn completion and usage (17266 input, 14208 cached, 8 output). Subscription remaining allowance and billing not independently verified.
- AUT-03: Git 2.55.0.windows.5; gh 2.105.0 authenticated as noeht-code via keyring; repository read verified by user terminal output.
- AUT-04: owner-authored [issue #1](https://github.com/noeht-code/dolevi-konsult/issues/1) retrieved by PowerShell, passed to Codex read-only, validated and reported back. ChatGPT retrieved [result comment](https://github.com/noeht-code/dolevi-konsult/issues/1#issuecomment-7175141227). No source code changes.

## AUT-05 — Bridge v0.1.0
Manual invocation of tools/bridge/Invoke-DoleviBridge.ps1 -Issue 1. Only the exact known smoke-test body is allowed; owner and open state checked. Temporary working directory, read-only sandbox, JSONL validation, fixed public result comment. Usage printed locally; failures stop locally without publishing raw logs. No arbitrary issue execution, write mode, polling, automatic merge or retries. Review script before running. Not yet executed on Windows; sandbox is not a guarantee against all access. Do not run unattended. Future versions require explicit authorization, isolated worktrees, safe reporting and tests. WP-01 iPhone acceptance remains open; WP-02 not started.
