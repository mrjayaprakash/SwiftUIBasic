//
//  MultiTouchScreenView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 02/07/25.
//

import SwiftUI

struct MultiTouchScreenView: View {
    @StateObject private var viewModel: MultiTouchTestViewModel
    @State private var isPresentingTest = false

    init(testcase: TestCase) {
        _viewModel = StateObject(wrappedValue: MultiTouchTestViewModel(testCase: testcase))
    }

    var body: some View {
        VStack {
            Text(viewModel.testCase.name)
                .font(.title2)

            if let testResult = viewModel.testResult {
                TestResultView(result: testResult)
            }

            Spacer()

            Button(DiagnosticStrings.runTest) {
                isPresentingTest = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .fullScreenCover(isPresented: $isPresentingTest) {
            MultiTouchTestView(viewModel: viewModel)
        }
    }
}
