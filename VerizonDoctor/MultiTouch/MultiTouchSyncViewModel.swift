//
//  Untitled.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 04/07/25.
//

import SwiftUI

class MultiTouchSyncViewModel: ObservableObject {
    @Published var isTouched: [Bool] = [false, false]
    @Published var targetPoints: [CGPoint] = [CGPoint.zero, CGPoint.zero]
    @Published var testCompleted = false
    @Published var testResult: TestResult? = nil

    private let touchTolerance: CGFloat = 45
    private let roundTimeLimit: TimeInterval = 10
    private let requiredRounds = 2
    private var currentRound = 0
    private var timer: Timer?
    let testCase: TestCase
    private var startTime: Date?
    
    private var roundStartTimes: [Date] = []
    private var roundCompletionTimes: [Date] = []
    private var firstRoundPassed = false
    private var secondRoundPassed = false
    private var passedRounds: Int {
        [firstRoundPassed, secondRoundPassed].filter { $0 }.count
    }
    private var failReason: String = "Timeout"
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }

    func configurePoints1(in size: CGSize) {
        let gap: CGFloat = 160
        let centerY = CGFloat.random(in: 150...(size.height - 150))
        let centerX = size.width / 2

        targetPoints[0] = CGPoint(x: centerX - gap / 2, y: centerY)
        targetPoints[1] = CGPoint(x: centerX + gap / 2, y: centerY)
    }
    
    func configurePoints(in size: CGSize) {
        let centerY = CGFloat.random(in: 150...(size.height - 150))
        let centerX = size.width / 2

        let gapRange: ClosedRange<CGFloat> = 120...220
        let gap = CGFloat.random(in: gapRange)

        let horizontalOffset = CGFloat.random(in: -40...40)

        // Introduce small horizontal shift or bias
        targetPoints[0] = CGPoint(x: centerX - gap / 2 + horizontalOffset, y: centerY)
        targetPoints[1] = CGPoint(x: centerX + gap / 2 + horizontalOffset, y: centerY)
    }

    func startTest(in size: CGSize) {
        startTime = Date()
        testCompleted = false
        currentRound = 0
        isTouched = [false, false]
        testResult = nil
        configurePoints(in: size)
        startTimer()
    }

    func evaluateTouches(_ detectedPoints: [CGPoint], in size: CGSize) {
        guard !testCompleted else { return }

        isTouched = [false, false]

        for (i, target) in targetPoints.enumerated() {
            for touch in detectedPoints {
                if CGPoint.distance(from: target, to: touch) <= touchTolerance {
                    isTouched[i] = true
                    break
                }
            }
        }

        if isTouched.allSatisfy({ $0 }) {
            timer?.invalidate()
            let now = Date()
            roundCompletionTimes.append(now)

            if currentRound == 0 {
                firstRoundPassed = true
            } else if currentRound == 1 {
                secondRoundPassed = true
            }
            currentRound += 1

            if currentRound >= requiredRounds {
                let duration = startTime.map { Date().timeIntervalSince($0) }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let firstRoundTime = self.roundCompletionTimes[0].timeIntervalSince(self.roundStartTimes[0])
                    let secondRoundTime = self.roundCompletionTimes[1].timeIntervalSince(self.roundStartTimes[1])

                    let testPassed = self.firstRoundPassed && self.secondRoundPassed
                    let reason = testPassed ? "None" : (!self.firstRoundPassed ? "Missed first round" : "Missed second round")

                    self.testCompleted = true
                    self.testResult = TestResult(
                        result: testPassed,
                        testCase: self.testCase,
                        summary: testPassed ? DiagnosticStrings.multiTouchPassSummary : DiagnosticStrings.multiTouchFailSummary,
                        details: testPassed ? DiagnosticStrings.multiTouchSuccessDetails : DiagnosticStrings.multiTouchFailureDetails,
                        output: [
                            "totalRounds": "2",
                            "passedRounds": "\(self.passedRounds)",
                            "failedRounds": "\(2 - self.passedRounds)",
                            "firstRoundTime": String(format: "%.2f", firstRoundTime),
                            "secondRoundTime": String(format: "%.2f", secondRoundTime),
                            "failReason": reason
                        ],
                        timestamp: now,
                        duration: duration,
                        metadata: [
                            "multiTouchAccuracy": String(format: "%.2f", Double(self.passedRounds) / 2.0),
                            "firstRoundPassed": self.firstRoundPassed,
                            "secondRoundPassed": self.secondRoundPassed,
                            "firstRoundTimeout": firstRoundTime > self.roundTimeLimit,
                            "secondRoundTimeout": secondRoundTime > self.roundTimeLimit,
                            "testPassed": testPassed
                        ]
                    )
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.isTouched = [false, false]
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.configurePoints(in: size)
                    self.startTimer()
                }
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        roundStartTimes.append(Date())
        timer = Timer.scheduledTimer(withTimeInterval: roundTimeLimit, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.testCompleted = true
            let now = Date()
            let duration = self.startTime.map { now.timeIntervalSince($0) }
            let firstRoundTime: TimeInterval
            if roundStartTimes.count > 0 && roundCompletionTimes.count > 0 {
                firstRoundTime = roundCompletionTimes[0].timeIntervalSince(roundStartTimes[0])
            } else {
                firstRoundTime = 10.0 // fallback for first round timeout
            }

            let secondRoundTime: TimeInterval
            let secondRoundStarted = roundStartTimes.count > 1

            if secondRoundStarted, roundCompletionTimes.count > 1 {
                secondRoundTime = roundCompletionTimes[1].timeIntervalSince(roundStartTimes[1])
            } else if secondRoundStarted {
                secondRoundTime = 10.0 // started but timed out
            } else {
                secondRoundTime = 0.0 // never began
            }

            let testPassed = false
            let failReason: String

            if self.currentRound == 0 {
                self.firstRoundPassed = false
                failReason = "Missed first round (timeout)"
            } else {
                self.secondRoundPassed = false
                failReason = "Missed second round (timeout)"
            }
            self.testResult = TestResult(
                result: testPassed,
                testCase: self.testCase,
                summary: DiagnosticStrings.multiTouchFailSummary,
                details: DiagnosticStrings.multiTouchFailureDetails,
                output: [
                    "totalRounds": "2",
                    "passedRounds": "\(self.passedRounds)",
                    "failedRounds": "\(2 - self.passedRounds)",
                    "firstRoundTime": String(format: "%.2f", firstRoundTime),
                    "secondRoundTime": String(format: "%.2f", secondRoundTime),
                    "failReason": failReason
                ],
                timestamp: now,
                duration: duration,
                metadata: [
                    "multiTouchAccuracy": String(format: "%.2f", Double(self.passedRounds) / 2.0),
                    "firstRoundPassed": self.firstRoundPassed,
                    "secondRoundPassed": self.secondRoundPassed,
                    "firstRoundTimeout": firstRoundTime > self.roundTimeLimit,
                    "secondRoundTimeout": secondRoundTime > self.roundTimeLimit,
                    "testPassed": testPassed
                ]
            )
        }
    }

    deinit {
        timer?.invalidate()
    }
}

extension CGPoint {
    static func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        hypot(p2.x - p1.x, p2.y - p1.y)
    }
}




