# Code review — TimeTracker 1.9.7

Date: 2026-11-25. Reviewed baseline: eda7c197d8cd522d1b0730b80add0909b4035551.
Scope: static review of central invoicing, settlement, backup, persistence and PDF paths in index.html, plus PWA shell references. Not a complete application audit or executed regression test. No runtime changes.

## Findings

| ID | Priority | Evidence (baseline index.html lines) | Required action |
|---|---|---|---|
| FIND-001 | High | 264–276, 367: invoiceItems and register read live entries/customer; archive HTML and snapshot already exist | Separate draft reads from immutable archived reads; test after return, repricing and rebilling (T07). |
| FIND-002 | High | 268, 322, 376–381, 426: hardcoded 25% VAT; configuration not used by these paths | Centralize monetary calculations; freeze VAT and totals on issue; explicitly handle legacy snapshots (T06–T08, T12, T15). |
| FIND-003 | High | 270–273: remaining balance clamped to zero; no refund ledger | Signed balance = original gross minus archived credits minus payments plus refunds; drafts have no effect (T11). |
| FIND-004 | High | 302–327: backup checks IDs, customer/project relationships and payments but not comprehensive invoice references, unique numbers, financial values or safe archive HTML | Validate new and legacy schemas, relationships, amounts and archive content before restore (T12–T13). |
| FIND-005 | Medium | 352–371: string-based number duplicate check, limited persistence verification; old restore can roll sequence back | Define number normalization and recovery policy; shared sequence for credits; test duplicates and failure (T06, T10, T13). |
| FIND-006 | Medium | 268–270, 376–381: floating-point calculations and inconsistent rounding paths | Define integer-öre totals and deterministic partial-credit allocation before implementation (T08, T11). |
| FIND-007 | Medium | 92, 273, 370–371: direct save; payment changes lack rollback; archive verification limited | Shared verified transaction persistence and failure handling; retain local storage keys (T13). |
| FIND-008 | Medium | 389–438: offline PDF uses frozen HTML for archived documents; ordinary invoice labels and fixed VAT note | Support credit type, original reference, reason and negative amounts; preserve original document; permanent PDF archive remains open (T15). |

## Proposed work packages

Use WP identifiers to avoid collision with approved CR-001–CR-012 requirement identifiers. These are sequencing proposals, not new approved product requirements.

1. WP-01 — immutable historical reads.
2. WP-02 — common monetary and VAT calculations.
3. WP-03 — credit drafts and full/partial credit issuance.
4. WP-04 — optional return of registrations, exactly once.
5. WP-05 — payments, refunds and signed balances.
6. WP-06 — persistence and backup compatibility (address transaction safety before financial writes).
7. WP-07 — credit PDF support.
8. WP-08 — approved TimeTracker name/icon.
9. WP-09 — regression and release.

Keep existing navigation, customer/project/article administration, time entry and report UI, PWA origin/scope and storage keys unless a specific approved change requires otherwise. No sync or backend. Resolve rounding, legacy VAT, stale drafts, refund corrections and return/repricing policy explicitly. Preserve original snapshots and separate current entry ownership from historical document lines.

## Evidence limits

No automated tests or installed-iPhone tests executed during this review. Remaining application paths and old backup fixtures require inspection. No claim of legal compliance or production readiness.
