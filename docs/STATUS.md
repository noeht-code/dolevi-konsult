# Status — 2026-11-25

Approved baseline: 1.9.7. Target: 1.10.0. Baseline commit: eda7c197d8cd522d1b0730b80add0909b4035551. Development branch: develop/1.10.0. Keep main unchanged until explicit release approval. GitHub Pages publishing source has not been independently verified in this session.

## Completed
- GitHub read/write access verified and repository reorganized at baseline commit; runtime file hashes unchanged.
- Static review of central invoice, payment, backup, persistence and PDF paths recorded in [CODE_REVIEW.md](CODE_REVIEW.md).
- Development branch created from baseline. WP-01 runtime changes implemented; credit implementation not started.
- Previous payment and backup tests reported successful; full regression evidence unavailable. Approved icon retained at ../assets/approved-icon.webp, not yet installed.

## Next steps
1. Inspect remaining archive read paths and legacy backup schemas; establish synthetic regression fixtures.
2. Implement and independently test immutable historical reads.
3. Resolve monetary rounding, legacy VAT and transaction safety; implement common calculations.
4. Implement credit drafts/issuance, optional return, refunds and signed balances; update schema and backup validation.
5. Adapt PDF and approved icon/name; preserve existing UI and PWA identity.
6. Execute automated regression tests, then installed-iPhone acceptance using an isolated test deployment; release only after approval.

Open: PDF preview and permanent PDF archive; Swedish compliance verification; robust production numbering/recovery; production initialization. All existing data is test data. Never commit real customer data or backups. No background work is running.

## WP-01 implementation
Historical register, receivable and backup amount reads now use archived entries/customer, never current entries for issued invoices. Missing legacy snapshots display unavailable history and disable payment registration; existing payment records are retained and their amount ceiling cannot be verified without historical entries. Draft reads remain live. Added synthetic Node regression test tests/wp01-history.test.cjs; passed in GitHub Actions. Chromium PDF and synthetic legacy backup tests also passed; installed-iPhone acceptance and authentic legacy export compatibility remain unverified. VAT and rounding remain unchanged for WP-02. No release or main update.

## WP-01 verification — 2026-11-25
Automated verification PASS at commit 26e4c33c09d88ed8607a5739a58bbbbe3860085c, [Actions run 45686910532](https://github.com/noeht-code/dolevi-konsult/actions/runs/45686910532). Both Node history assertions and Chromium backup restore, historical PDF byte equality, synthetic legacy fixture and overpayment checks passed. Earlier failures were runner compatibility and test checkbox event simulation. No application changes were needed for those failures. Automated WP-01 gate passed; final installed-iPhone acceptance and authentic legacy backup testing remain open. WP-02 not started. Main unchanged.
