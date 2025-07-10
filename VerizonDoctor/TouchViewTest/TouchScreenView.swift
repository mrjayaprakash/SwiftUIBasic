//
//  TouchScreenView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 27/06/25.
//
import SwiftUI

struct TouchScreenView: View {
    @StateObject private var viewModel: TouchTestViewModel
    @State private var isPresentingTouchTest = false
    
    init(testcase: TestCase) {
        _viewModel = StateObject(wrappedValue: TouchTestViewModel(testCase: testcase))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.testCase.name)
                .font(.title2)
            
            TestInstructionView(
                title: "Touch Test Instructions",
                steps: [
                    "Tap each blue square on the screen to complete the test.",
                    "Squares will turn green when touched successfully.",
                    "You must cover the entire screen area by tapping every cell.",
                    "Once all squares are cleared, the test will automatically pass."
                ]
            )
            
            if let testResult = viewModel.testResult {
                TestResultView(result: testResult)
            }
            Spacer()
            
            HStack {
                Button(DiagnosticStrings.runTest) {
                    isPresentingTouchTest = true
                }
                .buttonStyle(RunButtonStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(viewModel.testCase.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .fullScreenCover(isPresented: $isPresentingTouchTest) {
            TouchTestView(viewModel: viewModel)
        }
    }
}
