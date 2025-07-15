//
//  HomeView.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel
    @State private var isGridView = true
    @State private var isNavigatingToSummary = false
    @State private var selectedMode: TestMode = .system
    @State private var selectedCategory: String = "All test"
    @State private var isPresentingTouchTest = false
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 100), spacing: 10)]

    var body: some View {
        NavigationStack {
            VStack(spacing: 4) {
                HeaderView(selectedTestMode: $selectedMode, selectedCategory: $selectedCategory)
                
//                TextField("Search Test Cases", text: $homeViewModel.searchText)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(.horizontal)
//                    .padding(.vertical, 8)
                
                // Display grid or list
                Group {
                    if isGridView {
                        HomeGridView(
                            testCases: homeViewModel.filteredTestCases,
                            columns: columns,
                            selectedIDs: homeViewModel.selectedTestIDs,
                            getTestCaseView: { testCase in
                                AnyView(getTestCaseView(for: testCase))
                            }, toggleSelection: homeViewModel.toggleSelection
                        )
                    } else {
                        HomeListView(
                            testCases: homeViewModel.filteredTestCases,
                            selectedIDs: homeViewModel.selectedTestIDs,
                            toggleSelection: homeViewModel.toggleSelection
                        )
                    }
                }

                // Run Button (visible only in list mode)
//                if !isGridView {
                Button(DiagnosticStrings.runSelectedTest) {
                        homeViewModel.runSelectedTests {
                            isNavigatingToSummary = true
                        }
                    }
                    .disabled(homeViewModel.selectedTestIDs.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .navigationDestination(isPresented: $isNavigatingToSummary) {
                TestResultSummaryView(
                    viewModel: TestResultSummaryViewModel(results: homeViewModel.testResults)
                )
            }
        }
    }

    private func getTestCaseView(for testCase: TestCase) -> some View {
        switch testCase.type {
        case .gyroscope:
            return AnyView(GyrocopeView(testcase: testCase))
        case .accelerometer:
            return AnyView(AccelerometerView(testcase: testCase))
        case .magnetoMeter:
            return AnyView(MagnetometerView(testcase: testCase))
        case .speaker:
            return AnyView(GyrocopeView(testcase: testCase)) // Consider creating dedicated views if needed
        case .flashlight:
            return AnyView(FlashlightView(testcase: testCase))
        case .faceID:
            return AnyView(FaceIDView(testcase: testCase))
        case .touchScreen:
            return AnyView(TouchScreenView(testcase: testCase))
        case .badPixel:
            return AnyView(BadPixelTestView(testcase: testCase))
        case .multiTouch:
            return AnyView(MultiTouchView(testCase: testCase))
        case .camera:
            return AnyView(CameraTestView(testcase: testCase))
        }
    }
