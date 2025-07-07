//
//  MultiTouchView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 04/07/25.
//


import SwiftUI

struct MultiTouchView: View {
    let testCase: TestCase

    @StateObject private var viewModel: MultiTouchSyncViewModel
    @State private var isPresentingTest = false

    init(testCase: TestCase) {
        self.testCase = testCase
        _viewModel = StateObject(wrappedValue: MultiTouchSyncViewModel(testCase: testCase))
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(testCase.name)
                .font(.title2)
                .bold()

            TestInstructionView(
                title: "Multi-Touch Test Instructions",
                steps: [
                    "Use two fingers to tap both red circles simultaneously.",
                    "You must complete each round within 10 seconds.",
                    "After the first success, the circles will move — repeat once more.",
                    "If you fail to tap in time, the test fails."
                ]
            )

            if let result = viewModel.testResult {
                TestResultView(result: result)
            }

            Spacer()

            Button(DiagnosticStrings.runTest) {
                isPresentingTest = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .fullScreenCover(isPresented: $isPresentingTest) {
            MultiTouchSyncView(
                testCase: testCase,
                testResult: $viewModel.testResult,
                dismissAction: {
                    isPresentingTest = false
                }
            )
        }
    }
}

