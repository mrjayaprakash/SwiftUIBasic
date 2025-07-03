//
//  SwiftUIView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 02/07/25.
//

import Foundation
import SwiftUI

class MultiTouchTestViewModel: ObservableObject {
    @Published var clearedCells: Set<Int> = []
    @Published var showCompletionPrompt = false
    @Published var showResultOverlay = false
    @Published var testCompleted = false
    @Published var testPassed = false
    @Published var testResult: TestResult? = nil

    // ✅ New property to receive grid's position in screen space
    @Published var gridOffset: CGPoint = .zero

    let testCase: TestCase
    var gridSize = 0
    private var promptTimer: Timer?
    private var startTime: Date?

    init(testCase: TestCase) {
        self.testCase = testCase
    }

    func startTest() {
        clearedCells = []
        testCompleted = false
        testPassed = false
        showCompletionPrompt = false
        showResultOverlay = false
        startTime = Date()

        promptTimer?.invalidate()
        promptTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { [weak self] _ in
            guard let self = self, !self.testCompleted else { return }
            self.showCompletionPrompt = true
        }
    }

    func processFingerLocations(
        _ points: [CGPoint],
        screenSize: CGSize,
        cellSize: CGFloat,
        spacing: CGFloat,
        gridOriginX: CGFloat,
        gridOriginY: CGFloat,
        columnsCount: Int
    ) {
        guard !testCompleted else { return }

        for point in points {
            let localX = point.x - gridOriginX
            let localY = point.y - gridOriginY

            let totalGridWidth = CGFloat(columnsCount) * cellSize + CGFloat(columnsCount - 1) * spacing
            let totalGridHeight = CGFloat(gridSize / columnsCount) * cellSize + CGFloat((gridSize / columnsCount) - 1) * spacing

            guard localX >= 0, localY >= 0,
                  localX < totalGridWidth,
                  localY < totalGridHeight else { continue }

            let column = Int(localX / (cellSize + spacing))
            let row = Int(localY / (cellSize + spacing))
            let index = row * columnsCount + column

            if index >= 0 && index < gridSize {
                clearedCells.insert(index)
            }
        }

        if clearedCells.count == gridSize {
            testPassed = true
            finishTest(manualChoice: nil)
        }
    }

    func finishTest(manualChoice: Bool?) {
        testCompleted = true
        promptTimer?.invalidate()

        if let manual = manualChoice {
            testPassed = manual
        }

        showResultOverlay = true

        testResult = TestResult(
            result: testPassed,
            testCase: testCase,
            summary: testPassed ? DiagnosticStrings.touchPassSummary : DiagnosticStrings.touchFailSummary,
            details: testPassed ? DiagnosticStrings.touchSuccessDetails : DiagnosticStrings.touchFailureDetails,
            timestamp: Date(),
            duration: startTime.map { Date().timeIntervalSince($0) }
        )
    }
}
