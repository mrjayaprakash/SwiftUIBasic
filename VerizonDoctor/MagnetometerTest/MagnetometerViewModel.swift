//
//  MagnetometerViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
class MagnetometerViewModel: ObservableObject {
    @Published var testResult: TestResult?
    let testCase: TestCase
    private let testService: DiagnosticTestService
    
    init(testCase: TestCase, testService: DiagnosticTestService = DiagnosticTestService()) {
        self.testCase = testCase
        self.testService = testService
    }
    
    func runMagnetometerTest() {
       testService.executeTest(testCase) { [weak self] result in
             Task { @MainActor in
                 self?.testResult = result
             }
         }
     }}
