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

## ADR-002 — SRS algorithm: simplified SM-2

- **Date:** 2026-08-19
- **Status:** Accepted

**Context.** v1's core is spaced repetition. We need a scheduling algorithm that is
proven, simple to reason about, and easy to unit test on a tight timeline — it is also
the intended showcase for the project's testing story.

**Decision.** Implement a simplified **SM-2** as pure, framework-free Swift
(`SRSScheduler`, `SRSState`, `ReviewGrade`), with these specific choices:
- **Four-button grading** (again / hard / good / easy) mapped to SM-2 quality values
  (1 / 3 / 4 / 5) instead of exposing the raw 0...5 scale.
- The **ease factor is updated on every review** (classic SM-2), clamped to a 1.3 minimum.
- A **failed recall (`q < 3`) resets** repetitions and the interval to 1 day, while keeping
  the just-updated ease factor.
- **Time and calendar are injected**, never read from the system inside the algorithm, so
  scheduling is deterministic and fully unit-testable.

**Alternatives considered.**
- **Full SM-2 0...5 scale** — more granular, but users cannot reliably self-rate across six
  levels; worse UX for no practical gain here.
- **FSRS** (modern, more accurate) — significantly more complex to implement, explain, and
  test; overkill for v1. Worth revisiting later if scheduling quality becomes a priority.
- **Reproducing Anki's exact variant** — essentially SM-2 with tweaks; not worth copying.

**Consequences.**
- Pure domain logic with no persistence or UI coupling, covered by unit tests and enforced
  by CI — exactly the boundary described in [ADR-001](#adr-001--persistence-swiftdata-vs-core-data).
- The simplifications (no intra-session relearning; failure jumps straight to a 1-day
  interval) are acceptable for v1; a later ADR can add relearning steps if needed.
- Mapping `again` to `q = 1` (rather than `0`) applies a moderate rather than maximal ease
  penalty — a deliberate, documented choice.

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
