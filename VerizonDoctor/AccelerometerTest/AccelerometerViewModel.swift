//
//  AccelerometerViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
class AccelerometerViewModel: ObservableObject {
    @Published var testResult: TestResult?
    let testCase: TestCase
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    func runAccelerometerTest() {
        DiagnosticTestService.shared.executeTest(testCase) { restult in
            self.testResult = restult
            
        }
    }
}
