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
    var columns: [GridItem] = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    private let columnsCount = 3
    var body: some View {
        NavigationView {
                VStack {
                    if isGridView {
                        ScrollView {
//                            LazyVGrid(columns: Array(repeating:GridItem(.flexible(), spacing: 20), count:columnsCount), spacing: 20) {
                            LazyVGrid(columns:columns, spacing: 20) {
                                ForEach(homeViewModel.filteredTestCases) { testcase in
                                    NavigationLink(destination: getTestCaseView(for: testcase)){
                                        VStack {
                                            Image(testcase.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                            Text(testcase.name)
                                                .font(.subheadline)
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                        .searchable(text: $homeViewModel.searchText, prompt: "Search Test Cases")
                    } else {
                        List(homeViewModel.filteredTestCases){ testcase in
                            NavigationLink(destination: getTestCaseView(for: testcase)){
                                HStack {
                                    Image(testcase.icon)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text(testcase.name)
                                        .font(.headline)
                                }
                                .padding()
                            }
                        }
                        .searchable(text: $homeViewModel.searchText, prompt: "Search Test Cases")
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                    
                }
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
    
    //#Preview {
    //    HomeView()
    //}
    //            List(homeViewModel.testCases) { testCase in
    //                NavigationLink(destination: TestDetailView(testCase: testCase)){
    //                    Text(testCase.name)
    //                        .font(.headline)
    //                        .padding()
    //                }
    //            }
    //            .navigationTitle("Test Cases")
    //            .navigationBarTitleDisplayMode(.inline)
