//
//  BadPixelTestView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 30/06/25.
//

import SwiftUI
    
struct BadPixelTestView: View {
    let testCase: TestCase

    @StateObject private var viewModel: BadPixelTestViewModel
    
    init(testcase: TestCase) {
        self.testCase = testcase
        _viewModel = StateObject(wrappedValue: BadPixelTestViewModel(testCase: testcase))
    }
    
    var body: some View {
        ZStack {
            VStack {
                if let testResult = viewModel.testResult {
                    TestResultView(result: testResult)
                        .transition(.opacity)
                }
                if !viewModel.isTesting {
                    Text(viewModel.testCase.name)
                    
                        .font(.title2)
                        .padding(.top)

                    Button(DiagnosticStrings.runTest) {
                        viewModel.startTest()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()

            if viewModel.isTesting {
                VStack {
                    HStack {
                        Spacer()
                        Button(DiagnosticStrings.next) {
                            viewModel.nextColor()
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.5))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .zIndex(1)
                    }
                    Spacer()
                }
            }
            if viewModel.testCompleted && viewModel.passed == nil {
                ConfirmationDialog(
                    prompt: DiagnosticStrings.badPixelConfirmPrompt,
                    positiveActionLabel: DiagnosticStrings.badPixelNoIssues,
                    negativeActionLabel: DiagnosticStrings.badPixelIssueFound,
                    onConfirm: { passed in
                        viewModel.markResult(passed: passed)
                    }
                )
                .padding()
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .navigationTitle(viewModel.testCase.name)
        .navigationBarTitleDisplayMode(.inline)
    }


    private var backgroundColor: Color {
        viewModel.isTesting || viewModel.testCompleted ? viewModel.currentColor : Color(.systemBackground)
    }
}



