//
//  MultiTouchTestView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 02/07/25.
//



import SwiftUI

// ✅ PreferenceKey to track grid offset in global space
struct GridOffsetKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

struct MultiTouchTestView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MultiTouchTestViewModel
    var body: some View {
        GeometryReader { geometry in
            let cellSize: CGFloat = 70
            let spacing: CGFloat = 1

            let columnsCount = max(1, Int((geometry.size.width + spacing) / (cellSize + spacing)))
            let rowsCount = max(1, Int((geometry.size.height + spacing) / (cellSize + spacing)))
            let totalCells = rowsCount * columnsCount

            let columns = Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: columnsCount)

            let actualGridWidth = CGFloat(columnsCount) * cellSize + CGFloat(columnsCount - 1) * spacing
            let actualGridHeight = CGFloat(rowsCount) * cellSize + CGFloat(rowsCount - 1) * spacing

            ZStack {
                Color.white.ignoresSafeArea()

                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<totalCells, id: \.self) { index in
                        Rectangle()
                            .fill(viewModel.clearedCells.contains(index) ? .green : .blue)
                            .frame(width: cellSize, height: cellSize)
                            .cornerRadius(4)
                    }
                }
                .frame(width: actualGridWidth, height: actualGridHeight)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .background(
                    GeometryReader { gridGeometry in
                        let originInGlobal = gridGeometry.frame(in: .global).origin
                        Color.clear
                            .onAppear {
                                viewModel.gridOffset = originInGlobal
                            }
                            .onChange(of: originInGlobal) { newOrigin in
                                viewModel.gridOffset = newOrigin
                            }
                    }
                )
                .onPreferenceChange(GridOffsetKey.self) { origin in
                    viewModel.gridOffset = origin
                }

                // ✅ Multi-touch listener
                MultiTouchGestureView { points in
                    viewModel.processFingerLocations(
                        points,
                        screenSize: geometry.size,
                        cellSize: cellSize,
                        spacing: spacing,
                        gridOriginX: viewModel.gridOffset.x,
                        gridOriginY: viewModel.gridOffset.y,
                        columnsCount: columnsCount
                    )
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.clear)
                .ignoresSafeArea()

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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.7).ignoresSafeArea())
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
                }
            }
        }
    }
}

