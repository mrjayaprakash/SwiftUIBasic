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
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            let cellSize: CGFloat = 50
            let spacing: CGFloat = 6

            let columnsCount = Int((screenWidth + spacing) / (cellSize + spacing))
            let rowsCount = Int((screenHeight + spacing) / (cellSize + spacing))
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
                .padding(.top, spacing + 44) // Shift grid lower to avoid hitbox
                .padding([.horizontal, .bottom], spacing)
                .overlay(alignment: .topTrailing) {
                    CloseButtonView {
                        viewModel.finishTest()
                    }
                }
                // Overlay Timer
                VStack {
                    Text("⏱ \(viewModel.timeRemaining)s")
                        .font(.headline.bold())
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.top, 32)
                    Spacer()
                }

                // Result Overlay
                if viewModel.testCompleted {
                    TestResultOverlay(
                        passed: viewModel.testPassed,
                        title: viewModel.testPassed ? DiagnosticStrings.testPassed : DiagnosticStrings.testFailed,
                        onRestart: {
                            viewModel.startTest()
                        },
                        onDone: {
                            viewModel.finishTest()
                            dismiss()
                        }
                    )
                }
            }
            .onAppear {
                viewModel.gridSize = totalCells
                viewModel.startTest()
            }
        }
    }

}
struct CloseButtonView: View {
    let onClose: () -> Void

    var body: some View {
        Button(action: onClose) {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.black.opacity(0.001)) // Keeps tap area predictable
                .contentShape(Circle())
        }
        .frame(width: 44, height: 44)
        .padding()
    }
}





