# Architecture Decision Records

This file logs meaningful technical decisions and their trade-offs as they are made.
Newest entries go at the top. Each record is short and honest: what we chose, what we
gave up, and why.

## How to use this file

Copy the template below for every decision worth remembering (anything a future
reader — including an interviewer — might reasonably ask "why did you do it this way?").
Keep it to a few sentences per section.

```markdown
## ADR-NNN — <short title>

- **Date:** YYYY-MM-DD
- **Status:** Proposed | Accepted | Superseded by ADR-XXX

**Context.** What problem or question forced a choice? What constraints mattered
(deadline, learning goals, App Store, team of one)?

**Decision.** What did we choose?

**Alternatives considered.** What else was on the table, and why not?

**Consequences.** What does this make easier? What does it cost or risk later?
```

---

## ADR-001 — Persistence: SwiftData vs Core Data

- **Date:** 2026-08-09
- **Status:** Accepted

**Context.** Readloom needs local persistence for vocabulary cards and their SRS
scheduling state (see [README](README.md) for scope). The project targets iOS 17+ and
is a portfolio piece, so the choice should be defensible and modern without being
reckless. It is also a solo project on a tight timeline.

**Decision.** Use **SwiftData**. It is the current Apple-recommended API, integrates
cleanly with SwiftUI (`@Query`, `modelContainer`), and matches the "modern APIs" goal.
The data model (cards + SRS state) is simple, which is exactly where SwiftData is
strongest and where its rough edges (complex migrations, unusual queries) are least
likely to bite. The Xcode template already scaffolds it.

**Alternatives considered.**
- **Core Data** — more mature, better documented for edge cases, finer control over
  migrations and performance. Downsides: more boilerplate, older-feeling API, less
  aligned with the "showcase modern SwiftUI" narrative.
- **Plain files / SQLite / GRDB** — overkill or off-brand for this app; rejected.

**Consequences.**
- SwiftData keeps the data layer small and idiomatic, which helps the MVVM +
  repository story stay clean.
- Risk: SwiftData migrations and less-common queries are still maturing; if we hit a
  wall we may need to isolate persistence behind a repository protocol so a swap to
  Core Data stays cheap. That repository boundary is worth building regardless.
- Keeping the domain/SRS logic independent of the persistence framework (pure Swift,
  separately testable) mitigates most lock-in risk.
