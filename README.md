# Readloom

An iOS app for learning Chinese through spaced-repetition vocabulary practice, with
AI-assisted reading planned for a later version.

> **Status:** early development. This README describes the intended architecture and
> scope; sections marked _(planned)_ are not built yet.

<!-- TODO: add screenshots / GIF of the flashcard flow here once the UI exists. -->

## Features

### v1 — Vocabulary flashcards (in progress)
- Vocabulary cards with **pinyin**, **tones**, and **audio**.
- Initial dataset covering **HSK 1–2**.
- **Spaced-repetition scheduling** using a simplified **SM-2** algorithm.

### v2 — Adaptive reading _(planned)_
- AI-generated reading content adapted to the learner's level, prompting an LLM
  (Claude / OpenAI) using the vocabulary already mastered according to the SRS.
- Deferred intentionally: it is quick to add once the flashcard base is solid, and
  riskier to attempt first under a tight timeline.

## Tech stack

- **SwiftUI** for the UI
- **Swift Concurrency** (`async`/`await`) — no Combine
- **SwiftData** for persistence (see [DECISIONS.md](DECISIONS.md), ADR-001)
- **Swift Testing** for unit tests, **XCUIAutomation** for UI tests
- Targets **iOS 17+**, Swift 6.2

## Architecture

MVVM with clearly separated layers:

```
Views          SwiftUI views, no business logic
ViewModels     presentation state and intent, @Observable
Models         domain types (Card, Review, SRS state)
Services /     persistence and side effects behind protocols
Repositories   (dependency injection for testability)
```

- Dependency injection via **protocols** so services can be mocked in tests.
- The **SRS engine** is pure, framework-independent Swift logic — the primary target for
  unit tests, and a candidate to extract into its own **Swift Package**.
- Explicit error handling; no forced `try!` / `!`.

## Getting started

Requirements: Xcode 16+ (iOS 17 SDK or later).

```bash
git clone <repo-url>
cd Readloom
open Readloom/Readloom.xcodeproj
```

Build and run the `Readloom` scheme on an iOS 17+ simulator or device.

## Testing

Run unit and UI tests from Xcode (⌘U) or via `xcodebuild test`. Domain logic — the SRS
scheduler above all — is covered by unit tests.

## Development process

This project is also a showcase of engineering process:

- **Conventional Commits** (`feat:`, `fix:`, `refactor:`, `test:`) with small, focused commits.
- **Feature branches + Pull Requests**, each describing the decision and trade-offs.
- **CI on GitHub Actions**: build + tests on every push. _(planned)_
- **[DECISIONS.md](DECISIONS.md)** records architecture decisions as they are made.

## License

TBD.
