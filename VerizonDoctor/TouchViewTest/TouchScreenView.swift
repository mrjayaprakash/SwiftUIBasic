//
//  TouchScreenView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 27/06/25.
//
import SwiftUI

/*struct TouchScreenView: View {
    @State private var isPresentingTouchTest = false
    @StateObject private var viewModel: TouchTestViewModel
    
    init(testcase: TestCase){
        _viewModel = StateObject(wrappedValue: TouchTestViewModel(testCase: testcase))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.testCase.name)
                .font(.title2)

            Spacer()

            Button("Run Touch Test") {
                isPresentingTouchTest = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .sheet(isPresented: $isPresentingTouchTest) {
            TouchTestView(viewModel: viewModel, onClose: {
                isPresentingTouchTest = false
            })
        }
    }
}*/

struct TouchScreenView: View {
    @StateObject private var viewModel: TouchTestViewModel
    @State private var isPresentingTouchTest = false

    init(testcase: TestCase) {
        _viewModel = StateObject(wrappedValue: TouchTestViewModel(testCase: testcase))
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
                isPresentingTouchTest = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .sheet(isPresented: $isPresentingTouchTest) {
            TouchTestView(viewModel: viewModel)
            }
    }
}
