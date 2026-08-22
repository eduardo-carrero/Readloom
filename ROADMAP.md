# Roadmap

This roadmap tracks Readloom from an engineering-showcase perspective as much as a product
one. The guiding principle: **a small, impeccably engineered slice with a clear story is
worth more than a broad, messy feature set.** CI, pull requests with documented decisions,
[ADRs](DECISIONS.md), and tests are themselves deliverables.

**Estimation unit:** one *session* ≈ ~2 hours of focused work. Estimates are ranges because
debugging is unpredictable. Status: ✅ done · 🚧 in progress · ⬜ planned.

## Status at a glance

- ✅ Public repo, CI (build + unit tests on every push/PR), README, `DECISIONS.md`.
- ✅ SRS domain engine — simplified SM-2, pure and unit-tested ([ADR-002](DECISIONS.md)).
- 🚧 Data layer — `CardRepository`, SwiftData + in-memory implementations ([ADR-001](DECISIONS.md)).

## Milestone 1 — Minimum presentable portfolio

The point where someone can open the repo, see clean architecture + tests + CI + ADRs, and
run a working review session with audio.

| Phase | Task | Sessions (~2h) | Status |
|-------|------|----------------|--------|
| Data | Finish `CardRepository` + SwiftData impl, green CI, merge | 1–2 | 🚧 |
| Data | Seed dataset HSK 1–2 (JSON + idempotent loading + tests) | 2–3 | ⬜ |
| Review | `ReviewSessionViewModel`: due queue, grade → `SRSScheduler` → save (tested with in-memory repo) | 2 | ⬜ |
| Review | Review UI: card front/back, grade buttons, progress, empty/done states, repository DI | 3–4 | ⬜ |
| Audio | Pronunciation playback (decision: system TTS vs bundled audio) | 1–3 | ⬜ |
| Portfolio | README with screenshots/GIF, architecture section, "how I worked with AI" note | 1–2 | ⬜ |

_Estimate: ~10–15 sessions._

## Milestone 2 — Polished v1

| Phase | Task | Sessions (~2h) | Status |
|-------|------|----------------|--------|
| Review | Home/deck screen: due count, start session, browse deck | 2 | ⬜ |
| Polish | Accessibility + Dynamic Type pass, app icon, launch screen | 2–3 | ⬜ |

_Estimate: ~4–6 sessions._

## Milestone 3 — App Store (optional)

TestFlight, screenshots, privacy details, submission and review. ~3–5 sessions plus Apple's
review time.

## Later — v2: adaptive reading

AI-generated reading content adapted to the vocabulary the learner has mastered according to
the SRS (prompting an LLM). Intentionally deferred until the flashcard base is solid; see
[README](README.md).

## Open decision points

- **Audio:** system `AVSpeechSynthesizer` (zh-CN) — fast to build, robotic voice — vs bundled
  audio files — better quality, sourcing and app-size cost. TTS is enough to unblock Milestone 1.

## Methodology

Built with AI assistance (Claude Code) used critically, not as a black box: every change is
understood and defensible, notable decisions are captured as ADRs, and work lands through small
pull requests with conventional-commit history.
