//
//  FaceIDViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
class FaceIDViewModel: ObservableObject {
    @Published var testResult: TestResult?
    let testCase: TestCase
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    func runFaceIDTest() {
        DiagnosticTestService.shared.executeTest(testCase) { restult in
            self.testResult = restult
            
        }
    }
}


