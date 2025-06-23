//
//  GyrocopeViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
@MainActor
class GyrocopeViewModel: ObservableObject {
    @Published var testResult: TestResult?
    @Published var submissionState: ResultSubmissionState = .idle
    let testCase: TestCase
    
    init(testCase: TestCase) {
        self.testCase = testCase
    }
    func runGyroscopeTest1() {
        //testResult = DiagnosticTestService.shared.executeTest(testCase)
        DiagnosticTestService.shared.executeTest(testCase) { restult in
            self.testResult = restult
        }
    }
    
    func runGyroscopeTest2() {
        DiagnosticTestService.shared.executeTest(testCase) { [weak self] result in
            DispatchQueue.main.async {
                self?.testResult = result
            }
            Task {
                await self?.submitResultToServer()
            }
        }
    }
    
    func runGyroscopeTest() {
        DiagnosticTestService.shared.executeTest(testCase) { [weak self] result in
             Task { @MainActor in
                 self?.testResult = result
                 await self?.submitResultToServer()
             }
         }
     }
    
    //@MainActor
    private func submitResultToServer () async {
        guard let result = testResult else {
            submissionState = .failure(message: "No test result available to submit.")
            return
        }
        submissionState = .inProgress
        
        do {
            let dto = TestResultRequest(from: result)
            let response: TestResultResponse = try await NetworkClient.shared.post(
                data: dto,
                to: .submitResults
            )
            submissionState = .success(message: response.message ?? "")
        } catch {
            submissionState = .failure(message: error.localizedDescription)
        }
    }
    
}
