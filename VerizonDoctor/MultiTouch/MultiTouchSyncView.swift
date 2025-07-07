//
//  MultiTouchSyncView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 04/07/25.
//

import SwiftUI

struct MultiTouchSyncView: View {
    @Binding var testResult: TestResult?
    @StateObject private var viewModel: MultiTouchSyncViewModel
    var dismissAction: () -> Void
    @State private var isActive: [Bool] = [false, false]

    init(testCase: TestCase, testResult: Binding<TestResult?>, dismissAction: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: MultiTouchSyncViewModel(testCase: testCase))
        self._testResult = testResult
        self.dismissAction = dismissAction
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()

                ForEach(0..<2) { index in
                    ZStack {
                        //  Highlight glow
                        Circle()
                            .stroke(Color.green.opacity(isActive[index] ? 0.6 : 0), lineWidth: 14)
                            .frame(width: 110, height: 110)
                            .scaleEffect(isActive[index] ? 1.1 : 0.8)
                            .opacity(isActive[index] ? 1 : 0)
                            .animation(.easeOut(duration: 0.3), value: isActive[index])

                        //  Main target circle
                        Circle()
                            .fill(isActive[index] ? Color.green : Color.red)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(isActive[index] ? Color.white.opacity(0.8) : Color.clear, lineWidth: 3)
                            )
                    }
                    .position(viewModel.targetPoints[index])
                }
            }
            .onAppear {
                viewModel.startTest(in: geometry.size)
            }
            .onChange(of: viewModel.testCompleted) { completed in
                if completed {
                    testResult = viewModel.testResult
                    dismissAction()
                }
            }
            .overlay(
                MultiTouchSurfaceView { touches in
                    viewModel.evaluateTouches(touches, in: geometry.size)

                    for (i, match) in viewModel.isTouched.enumerated() {
                        if match {
                            isActive[i] = true
                        }
                    }

                    if !viewModel.testCompleted {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isActive = [false, false]
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .allowsHitTesting(true)
                .ignoresSafeArea()
            )
        }
    }
}


