//
//  HomeView.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var isGridView = false
    @State private var isNavigatingToSummary = false
    
    var columns: [GridItem] = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    private let columnsCount = 3
    var body: some View {
        NavigationView {
                VStack {
                    if isGridView {
                        ScrollView {
                            LazyVGrid(columns:columns, spacing: 16) {
                                ForEach(homeViewModel.filteredTestCases) { testcase in
//                                    let isSelected = homeViewModel.selectedTestIDs.contains(testcase.id)
                                    NavigationLink(destination: getTestCaseView(for: testcase)){
                                        VStack {
                                            Image(testcase.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                            Text(testcase.name)
                                                .font(.subheadline)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 100, height: 100)
//                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 2)
//                                            .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                                            )
//                                        .onTapGesture { homeViewModel.toggleSelection(for: testcase)
//                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                        }
//                        .searchable(text: $homeViewModel.searchText, prompt: "Search Test Cases")
                    } else {
                        List(homeViewModel.filteredTestCases){ testcase in
//                            NavigationLink(destination: getTestCaseView(for: testcase)){
                            let isSelected = homeViewModel.selectedTestIDs.contains(testcase.id)

                                HStack {
                                    Image(testcase.icon)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text(testcase.name)
                                        .font(.headline)
                                    Spacer()
                                    if isSelected {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .padding()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    homeViewModel.toggleSelection(for: testcase)
                                }
//                            }
                        }
//                        .searchable(text: $homeViewModel.searchText, prompt: "Search Test Cases")
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
                    }
                    // Run Button
                    if !isGridView {
                        Button("Run Selected Tests") {
                            homeViewModel.runSelectedTests {
                                isNavigatingToSummary = true
                            }
                        }
                        .disabled(homeViewModel.selectedTestIDs.isEmpty)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }


                    // Navigation to Summary
                    NavigationLink(
                        destination: TestResultSummaryView(
                            viewModel: TestResultSummaryViewModel(results: homeViewModel.testResults)
                        ),
                        isActive: $isNavigatingToSummary
                    ) {
                        EmptyView()
                    }
                    
                }
                .searchable(text: $homeViewModel.searchText, prompt: "Search Test Cases")
                .navigationTitle("Test Cases")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isGridView.toggle()}) {
                            Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                                .imageScale(.large)
                        }
                    }
                }
            }

        
        }
    func getTestCaseView(for testCase: TestCase) -> some View {
        switch testCase.type {
        case .gyroscope:
            return AnyView(GyrocopeView(testcase: testCase))
        case .accelerometer:
            return AnyView(AccelerometerView(testcase: testCase))
        case .magnetoMeter:
            return AnyView(MagnetometerView(testcase: testCase))
        case .speaker:
            return AnyView(GyrocopeView(testcase: testCase))
        case .camera:
            return AnyView(GyrocopeView(testcase: testCase))
        case .flashlight:
            return AnyView(FlashlightView(testcase: testCase))
        case .faceID:
            return AnyView(FaceIDView(testcase: testCase))
        }
    }
    }
