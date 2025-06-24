//
//  TestResultSummaryViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import Foundation


@MainActor
class TestResultSummaryViewModel: ObservableObject {
    @Published var selectedTests: [TestCase] = []
    @Published var testResults: [TestResult] = []
    @Published var submissionState: ResultSubmissionState = .idle

    private let testService: DiagnosticTestService

    init(results: [TestResult], testService: DiagnosticTestService = DiagnosticTestService()) {
        self.testResults = results
        self.testService = testService
    }
    
    func runSelectedTests() {
        testResults.removeAll()
        for testCase in selectedTests {
            testService.executeTest(testCase) { [weak self] result in
                Task { @MainActor in
                    self?.testResults.append(result)
                }
            }
        }
    }

    func uploadResultsToServer() async {
        guard !testResults.isEmpty else {
            submissionState = .failure(message: "No results to upload.")
            return
        }

        submissionState = .inProgress

        do {
            let payload = TestResultsUploadRequest(results: testResults.map {TestResultRequest(from: $0)})
            let response: TestResultResponse = try await NetworkClient.shared.post(
                data: payload,
                to: .submitResults
            )
            submissionState = .success(message: response.message ?? "")
        } catch {
            submissionState = .failure(message: error.localizedDescription)
        }
    }
}

//{
//  "results": [
//    { "testCase": "...", "result": true },
//    { "testCase": "...", "result": false }
//  ]
//}
