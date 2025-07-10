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
            currentRound += 1

            if currentRound >= requiredRounds {
                let duration = startTime.map { Date().timeIntervalSince($0) }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.testCompleted = true
                    self.testResult = TestResult(
                        result: true,
                        testCase: self.testCase,
                        summary: DiagnosticStrings.multiTouchPassSummary,
                        details: DiagnosticStrings.multiTouchSuccessDetails,
                        timestamp: Date(),
                        duration: duration
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
        timer = Timer.scheduledTimer(withTimeInterval: roundTimeLimit, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.testCompleted = true
            self.testResult = TestResult(
                result: false,
                testCase: self.testCase,
                summary: DiagnosticStrings.multiTouchFailSummary,
                details: DiagnosticStrings.multiTouchFailureDetails,
                timestamp: Date(),
                duration: startTime.map { Date().timeIntervalSince($0) }
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




