//
//  BadPixelColorTestView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 01/07/25.
//

import SwiftUI

struct BadPixelColorTestView: View {
    let colors: [Color]
    let onCompletion: (Bool) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var testCompleted = false
    
    var body: some View {
        ZStack {
            if testCompleted {
                ConfirmationDialog(
                    prompt: DiagnosticStrings.badPixelConfirmPrompt,
                    positiveActionLabel: DiagnosticStrings.badPixelNoIssues,
                    negativeActionLabel: DiagnosticStrings.badPixelIssueFound,
                    onConfirm: { passed in
                        onCompletion(passed)
                    }
                )
                .padding()
            } else {
                colors[currentIndex]
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            Task {
                for i in 0..<colors.count {
                    currentIndex = i
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                }
                testCompleted = true
            }
        }
    }
}

