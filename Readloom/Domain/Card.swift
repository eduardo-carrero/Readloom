//
//  Card.swift
//  Readloom
//

import Foundation

/// A single vocabulary card in a learner's deck.
///
/// A pure domain model with no persistence dependencies. The persistence layer
/// translates between this type and its stored representation, so the rest of
/// the app depends only on `Card`.
struct Card: Identifiable, Equatable, Sendable {
    let id: UUID
    /// The Chinese characters, e.g. "你好".
    let hanzi: String
    /// The romanised pronunciation with tone marks, e.g. "nǐ hǎo".
    let pinyin: String
    /// The English meaning, e.g. "hello".
    let meaning: String
    /// The card's spaced-repetition scheduling state.
    var srs: SRSState

    init(
        id: UUID = UUID(),
        hanzi: String,
        pinyin: String,
        meaning: String,
        srs: SRSState
    ) {
        self.id = id
        self.hanzi = hanzi
        self.pinyin = pinyin
        self.meaning = meaning
        self.srs = srs
    }
}
