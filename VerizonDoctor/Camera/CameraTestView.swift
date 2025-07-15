//
//  CameraTestView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 15/07/25.
//

import SwiftUI

struct CameraTestView: View {
    let testCase: TestCase

    @StateObject private var viewModel: CameraTestViewModel
    @State private var isPresentingCameraTest = false

    init(testcase: TestCase) {
        self.testCase = testcase
        _viewModel = StateObject(wrappedValue: CameraTestViewModel(testCase: testcase))
    }

    var body: some View {
        VStack {
            Text(testCase.name)
                .font(.title2)

            TestInstructionView(
                title: "Camera Test Instructions",
                steps: [
                    "Ensure your rear camera is clean and unobstructed.",
                    "Tap 'Run Test' to activate the camera in full-screen mode.",
                    "Use the tick button to capture a photo and check clarity.",
                    "Exposure values like ISO, Aperture, and EV will be displayed during focus.",
                    "After capturing, you can mark the result as Pass, Fail, or Retake.",
                    "If no action is taken within 10 seconds, the test will automatically fail and return to the results screen."
                ]
            )

            if let result = viewModel.testResult {
                TestResultView(result: result)
            }

            Spacer()

            Button(DiagnosticStrings.runTest) {
                isPresentingCameraTest = true
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(viewModel.testCase.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        
//        .fullScreenCover(isPresented: $isPresentingCameraTest) {
//            CameraFullTestExecutionView(viewModel: viewModel) { passed in
//                viewModel.markResult(passed: passed)
//                isPresentingCameraTest = false
//            }
//        }
        
        .fullScreenCover(isPresented: $isPresentingCameraTest) {
            CameraFullTestExecutionView(
                viewModel: viewModel,
                isPresented: $isPresentingCameraTest
            )
        }

    }
}
