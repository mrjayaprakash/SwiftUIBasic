//
//  TouchTestView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 26/06/25.
//


import SwiftUI

struct TouchTestView: View {
    @ObservedObject var viewModel: TouchTestViewModel
    @Environment(\.dismiss) private var dismiss

    private let cellSize: CGFloat = 60
    private let cellSpacing: CGFloat = 1

    var body: some View {
        let screenSize = UIScreen.main.bounds
        let columnsCount = Int(screenSize.width / (cellSize + cellSpacing))
        let rowsCount = Int(screenSize.height / (cellSize + cellSpacing))
        let totalCells = columnsCount * rowsCount
        let columns = Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: columnsCount)

        ZStack {
            Color.black.ignoresSafeArea() // Background base

            // Grid overlay
            LazyVGrid(columns: columns, spacing: cellSpacing) {
                ForEach(0..<totalCells, id: \.self) { index in
                    Rectangle()
                        .fill(viewModel.clearedCells.contains(index) ? .green : .blue)
                        .frame(width: cellSize, height: cellSize)
//                        .cornerRadius(4)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in viewModel.clearCell(index) }
                        )
                }
            }
            .frame(width: screenSize.width, height: screenSize.height)
            .ignoresSafeArea()

            //  Test Result Overlay
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
        .statusBar(hidden: true) //  Hide system UI
        .onAppear {
            viewModel.gridSize = totalCells
            viewModel.startTest()
        }
        .alert(DiagnosticStrings.testCompletionPromptTitle, isPresented: $viewModel.showCompletionPrompt) {
            Button(DiagnosticStrings.testCompletionPromptConfirm) {
                viewModel.finishTest(manualChoice: nil)
            }
            Button(DiagnosticStrings.testCompletionPromptCancel, role: .cancel) {
                viewModel.showCompletionPrompt = false
                viewModel.scheduleCompletionPrompt()
            }
        }
    }
}

/*
 Swiping
 struct TouchTestView: View {
    @ObservedObject var viewModel: TouchTestViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geometry in
            let cellSize: CGFloat = 60
            let spacing: CGFloat = 1

            let columnsCount = Int((geometry.size.width + spacing) / (cellSize + spacing))
            let rowsCount = Int((geometry.size.height + spacing) / (cellSize + spacing))
            let totalCells = rowsCount * columnsCount
            let columns = Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: columnsCount)

            ZStack {
                Color.white.ignoresSafeArea()

                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<totalCells, id: \.self) { index in
                        Rectangle()
                            .fill(viewModel.clearedCells.contains(index) ? .green : .blue)
                            .frame(width: cellSize, height: cellSize)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                // Multi-touch overlay tracker
                TouchCaptureView { point in
                    if let index = viewModel.indexForTouch(location: point, in: geometry.size, cellSize: cellSize, spacing: spacing) {
                        viewModel.clearCell(index)
                    }
                }

                // Test result overlay
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
            .alert("Are you done with the test?", isPresented: $viewModel.showCompletionPrompt) {
                Button("Yes") {
                    viewModel.finishTest(manualChoice: nil)
                }
                Button("No", role: .cancel) {
                    viewModel.showCompletionPrompt = false
                    viewModel.scheduleCompletionPrompt()
                }
            }
        }
    }
}*/

