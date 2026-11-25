# Status — 2026-11-25

Approved baseline: 1.9.7. Target: 1.10.0. Baseline commit: eda7c197d8cd522d1b0730b80add0909b4035551. Development branch: develop/1.10.0. Keep main unchanged until explicit release approval. GitHub Pages publishing source has not been independently verified in this session.

## Completed
- GitHub read/write access verified and repository reorganized at baseline commit; runtime file hashes unchanged.
- Static review of central invoice, payment, backup, persistence and PDF paths recorded in [CODE_REVIEW.md](CODE_REVIEW.md).
- Development branch created from baseline. No runtime changes or credit implementation yet.
- Previous payment and backup tests reported successful; full regression evidence unavailable. Approved icon retained at ../assets/approved-icon.webp, not yet installed.

## Next steps
1. Inspect remaining archive read paths and legacy backup schemas; establish synthetic regression fixtures.
2. Implement and independently test immutable historical reads.
3. Resolve monetary rounding, legacy VAT and transaction safety; implement common calculations.
4. Implement credit drafts/issuance, optional return, refunds and signed balances; update schema and backup validation.
5. Adapt PDF and approved icon/name; preserve existing UI and PWA identity.
6. Execute automated regression tests, then installed-iPhone acceptance using an isolated test deployment; release only after approval.

Open: PDF preview and permanent PDF archive; Swedish compliance verification; robust production numbering/recovery; production initialization. All existing data is test data. Never commit real customer data or backups. No background work is running.
