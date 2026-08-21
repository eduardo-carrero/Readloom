//
//  ReviewGrade.swift
//  Readloom
//

import Foundation

/// A learner's self-assessed recall quality for a card during review.
///
/// Readloom uses a simplified four-button model rather than the full SM-2
/// 0...5 quality scale. Each grade maps to an SM-2 quality value (`q`), which
/// ``SRSScheduler`` uses to update the card's ease factor and interval.
enum ReviewGrade: Int, CaseIterable, Sendable {
    /// Failed to recall the card. The schedule resets.
    case again = 1
    /// Recalled, but with serious difficulty.
    case hard = 3
    /// Recalled correctly after some hesitation.
    case good = 4
    /// Recalled effortlessly.
    case easy = 5

    /// The SM-2 quality value (`q`) for this grade, on the 0...5 scale.
    var quality: Int { rawValue }

    /// Whether this grade counts as a successful recall. SM-2 treats `q >= 3`
    /// as correct.
    var isCorrect: Bool { quality >= 3 }
}
