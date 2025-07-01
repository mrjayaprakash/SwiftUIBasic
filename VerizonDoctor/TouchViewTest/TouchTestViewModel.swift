//
//  TouchTestViewModel.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 26/06/25.
//

import Foundation

class TouchTestViewModel: ObservableObject {
    @Published var clearedCells: Set<Int> = []
    @Published var timeRemaining = 15
    @Published var testCompleted = false
    @Published var testPassed = false
    @Published var testResult: TestResult? = nil
    let testCase: TestCase
    var gridSize = 0
    private var timer: Timer?
    private var startTime: Date?
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    
    func startTest() {
        clearedCells = []
        timeRemaining = 100
        testCompleted = false
        testPassed = false
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.finishTest()
            }
        }
    }

    func clearCell(_ index: Int) {
        guard !testCompleted else { return }
        clearedCells.insert(index)
        if clearedCells.count == gridSize {
            finishTest()
        }
    }

    func finishTest() {
        testCompleted = true
        timer?.invalidate()
        testPassed = clearedCells.count == gridSize
        
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
