//
//  ConfirmationDialog.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 30/06/25.
//

import SwiftUI

struct ConfirmationDialog: View {
    let prompt: String
    let positiveActionLabel: String
    let negativeActionLabel: String
    let onConfirm: (Bool) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(prompt)
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: 24) {
                Button(positiveActionLabel) {
                    onConfirm(true)
                }

                Button(negativeActionLabel) {
                    onConfirm(false)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

