# Status — 2026-11-24

Approved baseline: 1.9.7. Target: 1.10.0. No completed credit implementation or new release is evidenced. User accepted design changes; previous payment and backup tests were reported successful. Full regression evidence is not available.

## Handover evidence
- Local release ZIP 1.9.7 inspected: index.html, sw.js, manifest, three icons, inherited requirements.
- Inherited requirements end at 1.9.4; current overlay records subsequent conversation decisions.
- Approved icon copied unchanged from supplied WebP. Not yet installed.
- Source inspection identified live-entry invoice history dependency and hardcoded VAT. No source code changed in this documentation handover.
- Live GitHub state not checked. Confirm repository matches baseline before work.

## Next steps
1. Establish baseline commit and regression fixtures; inspect all archive read paths and old backup schemas.
2. Implement immutable historical reads and test them independently.
3. Implement credit calculations, draft/issue workflow, return policy and refunds; document schema and rounding decisions.
4. Implement UI/PDF/backup changes and approved icon; preserve existing design.
5. Run automated tests and package only after passing; user tests on iPhone. Update status and changelog with actual evidence.

Open: PDF preview and permanent PDF archive; Swedish compliance verification; robust production numbering/recovery; production data initialization. Do not commit real customer data or backups. No background work is running.
