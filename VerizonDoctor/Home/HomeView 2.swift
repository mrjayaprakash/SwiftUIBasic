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
        case .multiTouch:
            return AnyView(TouchScreenView(testcase: testCase))
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
struct TouchTestView1: View {
    @ObservedObject var viewModel: TouchTestViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geometry in
            let cellSize: CGFloat = 50
            let spacing: CGFloat = 6
            let columnsCount = Int((geometry.size.width + spacing) / (cellSize + spacing))
            let rowsCount = Int((geometry.size.height + spacing) / (cellSize + spacing))
            let totalCells = rowsCount * columnsCount
            let columns = Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: columnsCount)

            ZStack {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<totalCells, id: \.self) { index in
                        Rectangle()
                            .fill(viewModel.clearedCells.contains(index) ? .green : .blue)
                            .frame(width: cellSize, height: cellSize)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in viewModel.clearCell(index) }
                            )
                    }
                }
                .padding(spacing)

                // ✅ Test result overlay
                if viewModel.showResultOverlay {
                    TestResultOverlay(
                        passed: viewModel.testPassed,
                        title: viewModel.testPassed ? DiagnosticStrings.testPassed : DiagnosticStrings.testFailed,
                        onRestart: {
                            viewModel.startTest()
                        },
                        onDone: {
                            dismiss()
                        }
                    )
                }
            }
            .onAppear {
                viewModel.gridSize = totalCells
                viewModel.startTest()
            }
            // ✅ "Are you done?" alert after 20 seconds
            .alert("Are you done with the test?", isPresented: $viewModel.showCompletionPrompt) {
                Button("Yes") {
                    viewModel.finishTest(manualChoice: nil)
                }
                Button("No", role: .cancel) {
                    viewModel.showCompletionPrompt = false
                }
            }
        }
    }
}

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
//enum TestMode: String, CaseIterable, Identifiable {
//    case system = "System"
//    case hardwar = "Hardware"
//    var id: String { rawValue }
//}
//
//struct HeaderView: View {
//    @Binding var selectedTestMode: TestMode
//
//    var body: some View {
//        let customRed: Color = Color(hex: 0xDB2F2D)
//        VStack(spacing: 16) {
//            HStack {
//                Text ("MVD Active Tests")
//                    .font(.title.bold())
//                    .foregroundColor(.yellow)
//                Spacer()
//
//                HStack(spacing: 16) {
//
//                    Button(action: {
//                    }) {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.white)
//                            .imageScale(.large)
//                    }
//                    Button(action: {
//                    }) {
//                        Image(systemName: "bubble.left")
//                            .foregroundColor(.white)
//                            .imageScale(.large)
//                    }
//                }
//
//            }
//            .background(customRed)
//            Picker("Test Mode", selection: $selectedTestMode) {
//                ForEach(TestMode.allCases) { mode in
//                    Text(mode.rawValue).tag(mode)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal)
//
//        }
//        .padding()
//        .background(customRed)
//    }
//}
//
//  MultiTouchSyncView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 04/07/25.
//

//import SwiftUI
//
//struct MultiTouchSyncView1: View {
//    @StateObject private var viewModel: MultiTouchSyncViewModel
//    var dismissAction: () -> Void
//
//    @State private var isActive: [Bool] = [false, false] // 💡 Visual feedback toggle per circle
//
//    init(testCase: TestCase, dismissAction: @escaping () -> Void) {
//        _viewModel = StateObject(wrappedValue: MultiTouchSyncViewModel(testCase: testCase))
//        self.dismissAction = dismissAction
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Color.white.ignoresSafeArea()
//
//                // 🎯 Target circles with color change and border glow
////                ForEach(0..<2) { index in
////                    Circle()
////                        .fill(isActive[index] ? Color.green : Color.blue)
////                        .frame(width: 80, height: 80)
////                        .position(viewModel.targetPoints[index])
////                        .animation(.easeInOut(duration: 0.2), value: isActive[index])
////                        .overlay(
////                            Circle()
////                                .stroke(isActive[index] ? Color.white.opacity(0.8) : Color.clear, lineWidth: 3)
////                        )
////                }
//                ForEach(0..<2) { index in
//                    ZStack {
//                        // Glowing ring
//                        Circle()
//                            .stroke(Color.green.opacity(isActive[index] ? 0.6 : 0), lineWidth: 12)
//                            .frame(width: 100, height: 100)
//                            .scaleEffect(isActive[index] ? 1.1 : 0.8)
//                            .opacity(isActive[index] ? 1 : 0)
//                            .animation(.easeOut(duration: 0.3), value: isActive[index])
//
//                        // Core circle
//                        Circle()
//                            .fill(isActive[index] ? Color.green : Color.blue)
//                            .frame(width: 80, height: 80)
//                            .overlay(
//                                Circle()
//                                    .stroke(isActive[index] ? Color.white.opacity(0.8) : Color.clear, lineWidth: 3)
//                            )
//                    }
//                    .position(viewModel.targetPoints[index])
//                }
//
//                // ✅ Result overlay after successful touch
//                if viewModel.testCompleted, let result = viewModel.testResult {
//                    VStack(spacing: 16) {
//                        Spacer()
//                        TestResultView(result: result)
//                        Button("Done") {
//                            dismissAction()
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(.blue)
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color.black.opacity(0.6).ignoresSafeArea())
//                }
//            }
//            .onAppear {
//                viewModel.configurePoints(in: geometry.size)
//                viewModel.startTest()
//            }
//            .overlay(
//                MultiTouchSurfaceView { touches in
//                    viewModel.evaluateTouches(touches)
//
//                    // ✅ Animate circles when touched
//                    for (i, matched) in viewModel.isTouched.enumerated() {
//                        if matched {
//                            isActive[i] = true
//                        }
//                    }
//
//                    // Delay highlight reset only if test is not completed
//                    if !viewModel.testCompleted {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                            isActive = [false, false]
//                        }
//                    }
//
//                    // Console debug
//                    print("Touches detected:", touches.map { "(\(Int($0.x)), \(Int($0.y)))" })
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.clear)
//                .allowsHitTesting(true)
//                .ignoresSafeArea()
//            )
//        }
//    }
//}


class MultiTouchSyncViewModel1: ObservableObject {
    @Published var isTouched: [Bool] = [false, false]
    @Published var targetPoints: [CGPoint] = [CGPoint.zero, CGPoint.zero]
    @Published var testCompleted = false
    @Published var testResult: TestResult? = nil

    private let radius: CGFloat = 40
    private let touchTolerance: CGFloat = 45
    private var startTime: Date?
    private let testCase: TestCase

    init(testCase: TestCase) {
        self.testCase = testCase
    }

    func configurePoints(in size: CGSize) {
        let gap: CGFloat = 160
        let centerY = size.height / 2
        let centerX = size.width / 2

        targetPoints[0] = CGPoint(x: centerX - gap / 2, y: centerY)
        targetPoints[1] = CGPoint(x: centerX + gap / 2, y: centerY)
    }

    func startTest() {
        testCompleted = false
        isTouched = [false, false]
        testResult = nil
        startTime = Date()
    }

    func evaluateTouches(_ detectedPoints: [CGPoint]) {
        guard !testCompleted else { return }

        isTouched = [false, false]

        for (i, target) in targetPoints.enumerated() {
            for touch in detectedPoints {
                if CGPoint.distance(from: target, to: touch) <= touchTolerance {
                    isTouched[i] = true
                    break
                }
            }
        }

        // ✅ Delay result overlay so animation can show
        if isTouched.allSatisfy({ $0 }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.testCompleted = true

                let duration = self.startTime.map { Date().timeIntervalSince($0) }

                self.testResult = TestResult(
                    result: true,
                    testCase: self.testCase,
                    summary: DiagnosticStrings.multiTouchPassSummary,
                    details: DiagnosticStrings.multiTouchSuccessDetails,
                    timestamp: Date(),
                    duration: duration
                )
            }
        }
    }
}

//struct MultiTouchView: View {
//
//    let testCase: TestCase
//
//    @StateObject private var viewModel: BadPixelTestViewModel
//    @State private var isPresentingColorTest = false
//
//    init(testcase: TestCase) {
//        self.testCase = testcase
//        _viewModel = StateObject(wrappedValue: BadPixelTestViewModel(testCase: testcase))
//    }
//
//    @State private var showTestView = false
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Multi-Touch Test")
//                .font(.title2)
//                .bold()
//
//            Text("Use two fingers to tap both red circles simultaneously. You’ll do this twice. Each round has a 10 second limit.")
//                .multilineTextAlignment(.center)
//                .padding()
//
//            Button("Run Test") {
//                viewModel.startTest()
//                showTestView = true
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .fullScreenCover(isPresented: $showTestView) {
//            MultiTouchTestView(viewModel: viewModel) {
//                showTestView = false
//            }
//        }
//        .onChange(of: viewModel.result) { _ in
//            // handle result here (pass/fail) when dismissed
//        }
//    }
//}

