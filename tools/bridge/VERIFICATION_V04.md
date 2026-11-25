# v0.4.1 verification gate

v0.4.0 positive pilot passed: https://github.com/noeht-code/dolevi-konsult/issues/4#issuecomment-7176097430
PR #5 independently inspected: only expected file. Closed without merge; issue #4 closed.
v0.4.1 adds atomic local per-issue claim before clone or Codex. Claims persist even on failure; no automatic retry. Single Windows user and PC only. Existing v0.4.0 runs are not migrated automatically. Do not use old runner for new tasks.
Pending: Windows execution, wrong hash, changed body, duplicate claim, wrong file and content, failure cleanup and no push. No unattended execution until verified. No application changes.
