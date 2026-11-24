# Architecture

## Observed baseline (1.9.7 release ZIP)
Single HTML/CSS/JavaScript application (`index.html`), static GitHub Pages hosting, `manifest.webmanifest`, `sw.js`, PNG icons. No backend or authentication. Service worker caches application shell, network-first navigation with offline fallback; cache `dolevi-shell-v1.9.7`. Manifest currently says Dolevi Konsult / Dolevi, Swedish, standalone. Local data key `dolevi-demo-v01`; separate clock key `dolevi-clock-start`. Preserve origin and keys for upgrades.

| Object | Relationship / observed fields |
|---|---|
| customers | numeric id, customer details |
| projects | id, customerId, project details and price |
| articles | id, article defaults |
| entries | id, projectId, articleId, date, quantity, price, comment; draftId or invoiceId |
| invoices | id, customerId, entryIds, status, dates; invoiceNumber, archiveHtml, archiveSnapshot, payments |
| archiveSnapshot | company, customer, entries, projects, invoice metadata |
| payments | id, date, amount, note |
| company / appConfig / invoiceSequence | company metadata, preferences, next number and legacy sequence |

Backup envelope `format: dolevi-demo-backup`, version and data. Restore validates arrays, IDs, project/customer relation and payment constraints, replaces state with confirmation. Validation is not comprehensive; do not assume all references are checked. Backups are plaintext.

## Critical findings for 1.10.0
- `invoiceItems(i)` reads live entries by entryIds; `invoiceRegisterCard(i)` uses those entries and live customer data. This is unsafe once entries are returned or repriced.
- `receivableTotal(i)` prefers archiveSnapshot.entries but falls back to live entries and hardcodes 25% VAT. Restore payment validation also uses 25%. Credit calculations must not blindly reuse this logic.
- `archiveTestInvoice(i)` freezes HTML and snapshots, assigns number from appConfig.nextInvoiceNumber and locks entries. Numbering is local only; older restore can roll it back.
- PDF is generated on demand, not a permanently archived PDF. Review all historical read paths including PDF, reports, list, payment panel and backup validation.

## Proposed target model (not implemented)
Use immutable original and credit snapshots with explicit line IDs, amounts, VAT and original invoice ID/number. Keep document lifecycle separate from derived settlement state. Store refund events separately with positive amounts. Keep historical entry IDs in snapshots and current billing ownership in live entries; retain explicit return event/history. No destructive mutation of issued document content.

Use integer öre for financial calculations and define rounding rules before coding. Validate cumulative credits per original line and document, including pending draft conflicts at archive time. Commit archive, number increment, return event and state together; verify persistence and failure behavior. Do not infer VAT from current company settings for old invoices. Preserve old schema through explicit migration/compatibility handling; test before saving migrated data.

Signed balance = original gross − archived credit gross (absolute) − payments + refunds. Positive is due, zero settled, negative refund due. Draft credits do not change balance. Credit and payment statuses are distinct dimensions.

## Deployment
Update version display and service worker cache together. For icon change deploy manifest and icons as well as index.html/sw.js. Keep PWA identity/scope stable. Back up before upgrade; verify version and offline restart on iPhone. No private data in repository or static assets.
