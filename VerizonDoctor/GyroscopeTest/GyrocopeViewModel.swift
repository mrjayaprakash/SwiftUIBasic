//
//  GyrocopeViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
class GyrocopeViewModel: ObservableObject {
    @Published var testResult: TestResult?
    let testCase: TestCase
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    func runGyroscopeTest() {
        //testResult = DiagnosticTestService.shared.executeTest(testCase)
        DiagnosticTestService.shared.executeTest(testCase) { restult in
            self.testResult = restult
            
        }
    }
}
