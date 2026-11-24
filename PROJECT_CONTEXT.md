# TimeTracker — project context

Baseline: 1.9.7 | Documentation snapshot: 2026-11-24 | Prototype only

TimeTracker (currently Dolevi Konsult in the installed app) is a mobile-first tool for Dolevi AB, a single-person consultancy. It records time and expenses, prepares invoices, tracks payments and exports records for external accounting. It is not an accounting system. Domestic Swedish B2B is the initial scope; native iOS, international invoicing and multi-device sync are future work.

Repository: https://github.com/noeht-code/dolevi-konsult
Deployment: https://noeht-code.github.io/dolevi-konsult/

## Working agreement
- GitHub is the intended source of truth. Verify the checked-out version before editing; the live repository was not inspected for this handover.
- Documentation and code in English; discussion and Swedish UI in Swedish. Preserve independent app/invoice language settings.
- Work in small versioned changes with requirements, acceptance criteria, tests and release notes. Do not invent results. Distinguish approved, implemented and verified.
- Primary acceptance platform is the installed iPhone PWA. Windows is used for development and GitHub uploads.
- All existing data and invoices are test data. Production requires separate approval, clean initialization and the correct starting invoice number.
- Never clear Safari storage or remove the installed PWA without a verified backup. Never commit customer backups or real invoices to GitHub.

## Reading order
1. STATUS.md — current baseline and next work.
2. REQUIREMENTS.md — current overrides and approved credit requirements.
3. ARCHITECTURE.md — observed implementation and proposed changes.
4. DECISIONS.md, TEST_PLAN.md and CHANGELOG.md.
5. history/REQUIREMENTS-v1.9.4.md — complete inherited specification, preserved verbatim. Current explicit overrides take precedence.

Start each new development session by reading these documents and inspecting actual source. End with changed files, test evidence, unresolved issues and updated status. Do not claim background development or completion without evidence.
