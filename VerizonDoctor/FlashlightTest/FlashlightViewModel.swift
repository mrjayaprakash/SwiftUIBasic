//
//  FlashlightViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
class FlashlightViewModel: ObservableObject {
    @Published var testResult: TestResult?
    let testCase: TestCase
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    
    func runFlashlightTest() {
        DiagnosticTestService.shared.executeTest(testCase) { restult in
            self.testResult = restult
            
        }
    }
}
