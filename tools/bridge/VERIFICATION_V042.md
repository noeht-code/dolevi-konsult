# v0.4.2 component tests

NEG-01 and NEG-02 passed on Windows from user console evidence, issue #6 closed. Shared claim, scope/content and cleanup functions extracted from v0.4.1. Run Test-BridgeChecks.ps1 locally. Tests do not invoke Codex, GitHub or push. NEG-06 tests cleanup component only; full failure reporting and no-publication integration remain pending. NEG-05 tests sequential duplicate claim, not concurrent process stress. v0.4.2 component suite executed successfully on Windows (user console evidence, 2026-11-25). No unattended execution.

## Windows evidence

```text
Positive scope control PASS
NEG-03 PASS
NEG-04 PASS
NEG-05 PASS
NEG-06 cleanup component PASS
LOCAL COMPONENT TESTS PASS
```

Full runner integration, concurrent claims and failure reporting/no-publication remain pending.
