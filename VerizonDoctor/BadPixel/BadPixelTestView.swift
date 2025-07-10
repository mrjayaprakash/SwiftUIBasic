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
    @State private var isPresentingColorTest = false
    
    init(testcase: TestCase) {
        self.testCase = testcase
        _viewModel = StateObject(wrappedValue: BadPixelTestViewModel(testCase: testcase))
    }
    
    var body: some View {
        VStack {
            Text(testCase.name)
                .font(.title2)
            TestInstructionView(
                title: "Bad Pixel Test Instructions",
                steps: [
                    "The screen will cycle through solid red, green, blue, black, and white backgrounds.",
                    "Each color will be displayed for 3 seconds.",
                    "Carefully observe the screen for any dead, stuck, or discolored pixels.",
                    "If the screen appears uniform without defects, mark the test as passed."
                ]
            )

            if let result = viewModel.testResult {
                TestResultView(result: result)
            }
            
            Spacer()
            
            Button(DiagnosticStrings.runTest) {
                isPresentingColorTest = true
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(viewModel.testCase.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .fullScreenCover(isPresented: $isPresentingColorTest) {
            BadPixelColorTestView(colors: viewModel.colors) { passed in
                viewModel.markResult(passed: passed)
                isPresentingColorTest = false
            }
        }
    }
    
    private var backgroundColor: Color {
        viewModel.isTesting || viewModel.testCompleted ? viewModel.currentColor : Color(.systemBackground)
    }
}
