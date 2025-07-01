//
//  HomeView.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import SwiftUI

struct HomeView2: View {
    @StateObject var homeViewModel = HomeViewModel()
    @State private var isGridView = false
    @State private var isNavigatingToSummary = false
    @State private var selectedMode: TestMode = .system
    
    var columns: [GridItem] = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    private let columnsCount = 3
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
//                    HeaderView(selectedTestMode: $selectedMode)
                    if isGridView {
                        // Grid View
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
                    } else {
                        // List View
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
        case .touchScreen:
            return AnyView(FaceIDView(testcase: testCase))
        case .badPixel:
            return AnyView(FaceIDView(testcase: testCase))
        }
    }
    }


/*struct HomeGridView: View {
    let testCases: [TestCase]
    let columns: [GridItem]
    let selectedIDs: Set<UUID>
    let getTestCaseView: (TestCase) -> AnyView
    let toggleSelection: (TestCase) -> Void
    let onTap: (TestCase) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(testCases) { testcase in
                    NavigationLink(destination: getTestCaseView(testcase)) {
                        let isSelected = selectedIDs.contains(testcase.id)
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(testcase.name)
                                .font(.headline)
                            Text("subtitle")
                                .font(.subheadline)
                        }
                        HStack {
                            Image(testcase.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            
                            Spacer()
                            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        
                    }
//                    .onTapGesture {
//                        toggleSelection(testcase)
//                    }
                        .padding()
                        .frame(width: 110, height: 140)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
//                                            .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                        )
                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}
*/
/*struct HomeGridView: View {
    let testCases: [TestCase]
    let columns: [GridItem]
    let selectedIDs: Set<UUID>
    let getTestCaseView: (TestCase) -> AnyView
    let toggleSelection: (TestCase) -> Void
    let onTap: (TestCase) -> Void

    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(testCases) { testCase in
                        let isSelected = selectedIDs.contains(testCase.id)

                        Button(action: {
                            onTap(testCase)
                        }) {
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(testCase.name)
                                        .font(.headline)
                                    Text("subtitle") // 📝 Replace with real subtitle if you have one
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                HStack {
                                    Image(testCase.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)

                                    Spacer()

                                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                }
                            }
                            .padding()
                            .frame(width: 110, height: 140)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
}*/
//import SwiftUI

/*struct TouchTestView: View {
    @StateObject private var viewModel = TouchTestViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)
//    let columns: [GridItem] = [
//        GridItem(.adaptive(minimum: 100), spacing: 16)
//    ]
    var body: some View {
        VStack(spacing: 20) {
            Text("Time Remaining: \(viewModel.timeRemaining)s")
                .font(.title2)
                .foregroundColor(viewModel.timeRemaining <= 5 ? .red : .primary)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<viewModel.gridSize, id: \.self) { index in
                    Rectangle()
                        .fill(viewModel.clearedCells.contains(index) ? .green : .blue)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in viewModel.clearCell(index) }
                        )
                }
            }
            .padding()

            if viewModel.testCompleted {
                Text(viewModel.testPassed ? "✅ Test Passed" : "❌ Test Failed")
                    .font(.title)
                    .bold()
                    .foregroundColor(viewModel.testPassed ? .green : .red)

                Button("Restart") {
                    viewModel.startTest()
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .onAppear {
            viewModel.startTest()
        }
    }
}*/
import SwiftUI

/*struct TouchTestView: View {
    @StateObject private var viewModel = TouchTestViewModel()
    private let spacing: CGFloat = 6
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 6)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                // Fullscreen grid
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<viewModel.gridSize, id: \.self) { index in
                        Rectangle()
                            .fill(viewModel.clearedCells.contains(index) ? .green : .blue)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in viewModel.clearCell(index) }
                            )
                    }
                }
                .padding(spacing)
                .frame(width: geometry.size.width, height: geometry.size.height)

                // 🕐 Timer Overlay
                VStack {
                    Text("⏱ \(viewModel.timeRemaining)s")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(viewModel.timeRemaining <= 5 ? .red : .white)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.top, 30)
                    Spacer()
                }

                // ✅/❌ Overlay Result
                if viewModel.testCompleted {
                    Color.black.opacity(0.5).ignoresSafeArea()

                    VStack(spacing: 16) {
                        Image(systemName: viewModel.testPassed ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(viewModel.testPassed ? .green : .red)

                        Text(viewModel.testPassed ? "Test Passed" : "Test Failed")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Button("Restart") {
                            viewModel.startTest()
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(.white)
                        .clipShape(Capsule())
                    }
                }
            }
            .onAppear {
                viewModel.startTest()
            }
        }
    }
}*/
