//
//  TouchTestViewModel.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 26/06/25.
//

import Foundation

class TouchTestViewModel: ObservableObject {
    @Published var clearedCells: Set<Int> = []
    @Published var showCompletionPrompt = false
    @Published var showResultOverlay = false
    @Published var testCompleted = false
    @Published var testPassed = false
    @Published var testResult: TestResult? = nil

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
        scheduleCompletionPrompt()
    }

    func clearCell(_ index: Int) {
        guard !testCompleted else { return }
        clearedCells.insert(index)

        if clearedCells.count == gridSize {
            testPassed = true
            finishTest(manualChoice: nil) // auto-pass
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
    func scheduleCompletionPrompt() {
        promptTimer?.invalidate()
        promptTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            guard let self = self, !self.testCompleted else { return }
            self.showCompletionPrompt = true
        }
    }
    
    func indexForTouch(location: CGPoint, in screenSize: CGSize, cellSize: CGFloat, spacing: CGFloat) -> Int? {
        let columnsCount = Int((screenSize.width + spacing) / (cellSize + spacing))
        let column = Int(location.x / (cellSize + spacing))
        let row = Int(location.y / (cellSize + spacing))
        let index = row * columnsCount + column
        return index >= 0 && index < gridSize ? index : nil
    }
}
