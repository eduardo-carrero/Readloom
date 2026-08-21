//
//  SRSSchedulerTests.swift
//  ReadloomTests
//

import Foundation
import Testing
@testable import Readloom

struct SRSSchedulerTests {

    // MARK: - Deterministic fixtures

    /// A fixed review instant, so scheduling output is fully reproducible.
    static let now = Date(timeIntervalSince1970: 1_700_000_000)

    /// A UTC calendar, so adding day-based intervals is exactly 86_400 seconds
    /// and free of daylight-saving surprises.
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar
    }()

    private func schedule(_ state: SRSState, _ grade: ReviewGrade) -> SRSState {
        SRSScheduler.next(state, grade: grade, reviewedAt: Self.now, calendar: Self.calendar)
    }

    private func dueDate(daysFromNow days: Int) throws -> Date {
        try #require(Self.calendar.date(byAdding: .day, value: days, to: Self.now))
    }

    private func isClose(_ lhs: Double, _ rhs: Double, tolerance: Double = 1e-9) -> Bool {
        abs(lhs - rhs) <= tolerance
    }

    // MARK: - New card state

    @Test("A new card starts with default SM-2 values and is due immediately")
    func newStateDefaults() {
        let state = SRSState.new(dueDate: Self.now)

        #expect(state.easeFactor == SRSScheduler.defaultEaseFactor)
        #expect(state.interval == 0)
        #expect(state.repetitions == 0)
        #expect(state.dueDate == Self.now)
    }

    // MARK: - Successful recall progression

    @Test("A new card graded good is scheduled one day out")
    func firstGoodReview() throws {
        let result = schedule(.new(dueDate: Self.now), .good)

        #expect(result.repetitions == 1)
        #expect(result.interval == 1)
        #expect(isClose(result.easeFactor, 2.5)) // q = 4 leaves the ease factor unchanged
        #expect(result.dueDate == (try dueDate(daysFromNow: 1)))
    }

    @Test("A second successful recall is scheduled six days out")
    func secondGoodReview() throws {
        var state = SRSState.new(dueDate: Self.now)
        state = schedule(state, .good)
        let result = schedule(state, .good)

        #expect(result.repetitions == 2)
        #expect(result.interval == 6)
        #expect(result.dueDate == (try dueDate(daysFromNow: 6)))
    }

    @Test("The third recall multiplies the previous interval by the ease factor")
    func thirdReviewMultipliesByEaseFactor() throws {
        var state = SRSState.new(dueDate: Self.now)
        state = schedule(state, .good) // interval 1, ease 2.5
        state = schedule(state, .good) // interval 6, ease 2.5
        let result = schedule(state, .good) // interval round(6 * 2.5) = 15

        #expect(result.repetitions == 3)
        #expect(result.interval == 15)
        #expect(isClose(result.easeFactor, 2.5))
        #expect(result.dueDate == (try dueDate(daysFromNow: 15)))
    }

    // MARK: - Failure

    @Test("A failed recall resets repetitions and interval but keeps the updated ease factor")
    func failureResetsSchedule() throws {
        let matured = SRSState(easeFactor: 2.5, interval: 15, repetitions: 3, dueDate: Self.now)
        let result = schedule(matured, .again)

        #expect(result.repetitions == 0)
        #expect(result.interval == 1)
        #expect(isClose(result.easeFactor, 1.96)) // 2.5 - 0.54 for q = 1
        #expect(result.dueDate == (try dueDate(daysFromNow: 1)))
    }

    // MARK: - Ease factor bounds and adjustment

    @Test("The ease factor never drops below the SM-2 minimum")
    func easeFactorClampedToMinimum() {
        var state = SRSState(easeFactor: 1.3, interval: 10, repetitions: 5, dueDate: Self.now)

        for _ in 0..<5 {
            state = schedule(state, .again)
        }

        #expect(state.easeFactor >= SRSScheduler.minimumEaseFactor)
        #expect(isClose(state.easeFactor, SRSScheduler.minimumEaseFactor))
    }

    @Test(
        "Each grade adjusts the ease factor by the SM-2 amount",
        arguments: [
            (ReviewGrade.easy, 2.6),
            (ReviewGrade.good, 2.5),
            (ReviewGrade.hard, 2.36),
            (ReviewGrade.again, 1.96),
        ]
    )
    func easeFactorAdjustmentPerGrade(grade: ReviewGrade, expectedEaseFactor: Double) {
        let result = schedule(.new(dueDate: Self.now), grade)
        #expect(isClose(result.easeFactor, expectedEaseFactor))
    }
}
