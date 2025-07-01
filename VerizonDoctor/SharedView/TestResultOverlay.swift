//
//  TestResultOverlay.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 30/06/25.
//

import SwiftUI

struct TestResultOverlay: View {
    let passed: Bool
    let title: String?
    let onRestart: () -> Void
    let onDone: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(passed ? .green : .red)

                if let title = title {
                    Text(title)
                        .font(.title.bold())
                        .foregroundColor(.white)
                }

                Button(DiagnosticStrings.restart) {
                    onRestart()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(Capsule())

                Button(DiagnosticStrings.done) {
                    onDone()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(Capsule())
            }
        }
    }
}

