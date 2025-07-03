//
//  BadPixelTestViewModel.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 30/06/25.
//

import SwiftUI

class BadPixelTestViewModel: ObservableObject {
    @Published var isTesting = false
    @Published var currentIndex = 0
    @Published var testCompleted = false
    @Published var passed: Bool? = nil
    @Published var testResult: TestResult? = nil
    let testCase: TestCase
    private var startTime: Date?
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    
    let colors: [Color] = [.red, .green, .blue, .black, .white]
    
    var currentColor: Color {
        colors[currentIndex]
    }
    
    func startTest() {
        isTesting = true
        currentIndex = 0
        testCompleted = false
        passed = nil
        testResult = nil
        startTime = Date()
    }
    
    func nextColor() {
        if currentIndex < colors.count - 1 {
            currentIndex += 1
        } else {
            isTesting = false
            testCompleted = true
        }
    }
    
    func markResult(passed: Bool) {
        self.passed = passed
        let duration = startTime.map { Date().timeIntervalSince($0) }
        self.testResult = TestResult(
            result: passed,
            testCase: testCase,
            summary: passed ? DiagnosticStrings.badPixelPassSummary : DiagnosticStrings.badPixelFailSummary,
            details: passed ? DiagnosticStrings.badPixelSuccessDetails : DiagnosticStrings.badPixelFailureDetails,
            timestamp: Date(),
            duration: duration
        )
    }
    func restart() {
        testResult = nil
        startTest()
    }
}
