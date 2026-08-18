//
//  SRSScheduler.swift
//  Readloom
//

import Foundation

/// A pure, deterministic implementation of a simplified SM-2 spaced-repetition
/// algorithm.
///
/// The scheduler takes the current ``SRSState`` and a ``ReviewGrade`` and
/// returns the next state. It reads no global state — the review time and the
/// calendar are injected — so its output is fully determined by its inputs,
/// which makes it straightforward to unit test.
///
/// The algorithm follows the classic SM-2 rules (see
/// <https://super-memory.com/english/ol/sm2.htm>): the ease factor is updated
/// on every review, and a failed recall (`q < 3`) restarts the interval
/// schedule while keeping the updated ease factor.
enum SRSScheduler {
    /// The ease factor assigned to a new card.
    static let defaultEaseFactor = 2.5

    /// The lowest value the ease factor may take, per SM-2.
    static let minimumEaseFactor = 1.3

    /// Computes the next scheduling state for a card after a review.
    ///
    /// - Parameters:
    ///   - state: The card's current scheduling state.
    ///   - grade: The learner's self-assessed recall quality.
    ///   - now: The moment the review took place. The next due date is measured
    ///     from this instant.
    ///   - calendar: The calendar used to add day-based intervals. Defaults to
    ///     the current calendar; inject a fixed calendar for deterministic tests.
    /// - Returns: The updated scheduling state.
    static func next(
        _ state: SRSState,
        grade: ReviewGrade,
        reviewedAt now: Date,
        calendar: Calendar = .current
    ) -> SRSState {
        let easeFactor = updatedEaseFactor(state.easeFactor, quality: grade.quality)

        let repetitions: Int
        let interval: Int

        if grade.isCorrect {
            repetitions = state.repetitions + 1
            interval = nextInterval(
                repetitions: repetitions,
                previousInterval: state.interval,
                easeFactor: easeFactor
            )
        } else {
            repetitions = 0
            interval = 1
        }

        let dueDate = calendar.date(byAdding: .day, value: interval, to: now) ?? now

        return SRSState(
            easeFactor: easeFactor,
            interval: interval,
            repetitions: repetitions,
            dueDate: dueDate
        )
    }

    /// Applies the SM-2 ease-factor update for a given quality, clamped to the
    /// minimum. Applied on every review, including failures.
    private static func updatedEaseFactor(_ current: Double, quality: Int) -> Double {
        let q = Double(quality)
        let updated = current + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
        return max(updated, minimumEaseFactor)
    }

    /// The next interval in days for a successful recall.
    ///
    /// The first successful recall is scheduled one day out, the second six days
    /// out, and each subsequent recall multiplies the previous interval by the
    /// ease factor.
    private static func nextInterval(
        repetitions: Int,
        previousInterval: Int,
        easeFactor: Double
    ) -> Int {
        switch repetitions {
        case 1: return 1
        case 2: return 6
        default: return Int((Double(previousInterval) * easeFactor).rounded())
        }
    }
}
