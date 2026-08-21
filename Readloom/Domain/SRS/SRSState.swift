//
//  SRSState.swift
//  Readloom
//

import Foundation

/// The spaced-repetition scheduling state for a single card, following a
/// simplified SM-2 algorithm.
///
/// This is pure domain data with no dependency on SwiftData or any other
/// persistence framework. Keeping it framework-free is what lets
/// ``SRSScheduler`` stay trivially testable and independent of storage.
struct SRSState: Equatable, Sendable {
    /// The SM-2 ease factor. Higher means the card is easier and its intervals
    /// grow faster. Clamped to ``SRSScheduler/minimumEaseFactor``.
    var easeFactor: Double

    /// The current interval, in whole days, until the next review.
    var interval: Int

    /// The number of consecutive successful recalls.
    var repetitions: Int

    /// The moment at which the card next becomes due for review.
    var dueDate: Date

    /// The scheduling state for a brand-new card, due immediately at `dueDate`.
    static func new(dueDate: Date) -> SRSState {
        SRSState(
            easeFactor: SRSScheduler.defaultEaseFactor,
            interval: 0,
            repetitions: 0,
            dueDate: dueDate
        )
    }
}
