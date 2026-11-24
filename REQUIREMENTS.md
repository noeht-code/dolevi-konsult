# Current requirements — baseline 1.9.7 / target 1.10.0

The inherited requirements and identifiers are retained in [the historical specification](history/REQUIREMENTS-v1.9.4.md), extracted unchanged from the 1.9.7 release ZIP. This document is the controlling overlay: later explicit decisions supersede conflicting historical text. Historical P/B/F/Ö labels are not new verification evidence.

## Current baseline requirements
| ID | Requirement |
|---|---|
| UI-01 | Five tabs: Kunder, Tid, Rapporter, Fakturor, Företag. Articles under Företag. |
| UI-02/03 | Contrasting customer cards, white project cards; customer details via chevron, explicit edit action. |
| UI-07 | Today on entering Tid; selected date persists within tab, +/- one day; editing preserves original date. Supersedes old blank-date requirement. |
| TIME-01 | Compact entry rows with date, article, quantity and detail chevron; collapsible customer/project/filter panel. |
| TIME-02 | Defaults: all dates, unbilled (including draft reservations), all types; newest first; 30 rows then Visa 30 till. Current/previous month options. Draft marker and edit lock. |
| TIME-03 | Center date, equal-height date controls, compact start/end fields, unchanged clock buttons. Quantity keypad supports decimal comma and explicit Klar; does not save entry itself. |
| REP-01 | Collapsible report filters; default all customers, all projects, unbilled. Preserve existing date range behavior, center date fields, symmetric chevrons. Compact count and total with labels above. Preserve selection, CSV and draft creation. |
| ART-01 | Compact article list with name, unit, price and chevron; separate details/edit; preserve historical names/prices. |
| PRICE-01 | Project hourly price supersedes old customer default; article default and registration override; historical values remain frozen. |
| PAY-01 | Multiple dated payments, notes, undo confirmation, derived balances and statuses; include in backup. |
| BACK-01 | Explicit JSON export/restore, preview and confirmation; replacement not merge; compatible with 1.8.4 backup without entry.customerId. |
| INV-01 | Drafts unnumbered; archive test copies with unique sequential number, frozen HTML and snapshot. No real issuance in prototype. |

## Approved target: credit invoices (not implemented)
| ID | Requirement |
|---|---|
| CR-001 | Original issued document remains immutable. |
| CR-002 | Issued credit document cannot be edited or deleted. |
| CR-003 | Cumulative credit cannot exceed original amount, including per-line limits. |
| CR-004 | Full and multiple partial credits, including part of a line amount. |
| CR-005 | Use historical prices and VAT rates, original party details and unambiguous original invoice reference. |
| CR-006 | At full cumulative credit, explicitly choose whether to return registrations for rebilling or keep closed; never return twice. |
| CR-007 | Drafts consume no number; credit documents share normal sequential numbering on archive. |
| CR-008 | Credit documents, links and refunds included in backup. |
| CR-009 | Existing backups remain readable. |
| CR-010 | Refunds recorded separately from payments and credits. |
| CR-011 | Mandatory reason (product rule), issue date, own PDF and archived snapshot; negative credit totals and VAT. |
| CR-012 | Derive net receivable from original total minus credits minus payments plus refunds. Negative balance means refund due; credit does not itself move money. |
| ICON-01 | Use exact approved image in assets/approved-icon.webp; generate 180/192/512 PNGs, update PWA metadata/cache; verify installed iPhone icon. |

Workflow: open archived original → create credit draft → choose full/partial → select amounts and reason → choose return policy if fully credited → review → archive numbered test credit → update balance. Original history remains accessible after rebilling.

## Compliance and open issues
Earlier discussion identified Swedish amendment-invoice requirements (reference, changed amounts, date and VAT). Treat this as a design basis, not independently verified legal sign-off. Recheck current Skatteverket guidance before production: https://www.skatteverket.se/ . Full invoice compliance, durable archive, numbering across restores/devices and PDF fidelity remain release gates. No live bookkeeping or bank integration.

Open implementation details: rounding/allocation across partial credits; handling old snapshots without explicit VAT; concurrent drafts and stale state; correction of refunds; exact price-edit workflow after return. Resolve and document before release; do not silently invent policy.
