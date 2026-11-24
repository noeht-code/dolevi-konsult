# Test plan

All tests below are planned unless evidence is explicitly recorded. Use synthetic data only. Record version/commit, environment, inputs, expected/actual result and PASS/FAIL. Preserve a pre-upgrade backup outside GitHub.

| ID | Coverage | Expected result |
|---|---|---|
| T01 | Upgrade 1.9.7, offline restart | Correct version; existing data retained |
| T02 | Customer/project/article edits and archive | Historical entry values and invoices unchanged |
| T03 | Time defaults, month/year boundary, 31+ rows, draft marker | Correct filter before pagination, locks intact |
| T04 | iPhone date, clock, decimal keypad, report panel | No overlap; correct values and explicit Klar |
| T05 | Report selection, CSV, draft create/delete | Correct totals; reservations released on deletion |
| T06 | Archive ordinary invoice | Unique next number; immutable snapshot |
| T07 | CR-001/002/005/006 | Compare original HTML, snapshot, PDF content and register before/after credit, repricing and rebilling | 
| T08 | CR-003/004 | Multiple partial credits, exact limit accepted, excess rejected per line and total |
| T09 | CR-006 | Full credit with return and without return; return only once; new invoice has independent history |
| T10 | CR-007/011 | Draft cancellation consumes no number; archived credit has own number, original reference, reason, correct negative totals |
| T11 | CR-010/012 | Settlement cases below, refund separate; draft has no financial effect |
| T12 | CR-008/009 | Restore old 1.8.4 and 1.9.7 backups; round-trip new credits/refunds/return history |
| T13 | Invalid backup / stale draft / storage failure | Reject invalid state, no partial archive or duplicate number |
| T14 | ICON-01 | Exact approved artwork at required sizes; verify iPhone icon, PWA identity and offline cache |
| T15 | PDF and archive | Credit and original readable, correct numbers, parties, VAT, references, attachments; no live-data drift |

T07 expected: original archived document and historical values remain identical; only derived settlement information changes.

## Settlement fixtures (SEK, gross original 100,000)
| Payments | Credits | Refunds | Expected balance |
|---:|---:|---:|---:|
| 0 | 100000 | 0 | 0 |
| 0 | 20000 | 0 | 80000 |
| 40000 | 20000 | 0 | 40000 |
| 40000 | 100000 | 0 | -40000 |
| 100000 | 20000 | 0 | -20000 |
| 100000 | 100000 | 0 | -100000 |
| 100000 | 100000 | 100000 | 0 |

Add fractional quantity, rounding, multiple VAT rates if supported, repeated credits, refund limits and malformed references. Automated domain tests plus manual installed-iPhone acceptance required. Production requires separate legal, archival, numbering and recovery verification.
