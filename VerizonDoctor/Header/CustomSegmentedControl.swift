//
//  CustomSegmentedControl.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 01/07/25.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedMode: TestMode
    private let customRed = Color(hex: 0xDB2F2D)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TestMode.allCases) { mode in
                Button(action: {
                    withAnimation {
                        selectedMode = mode
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(mode.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selectedMode == mode ? customRed : .gray)

                        // Red underline for selected tab
                        Rectangle()
                            .fill(selectedMode == mode ? customRed : Color.clear)
                            .frame(height: 4)
                            .cornerRadius(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
    }
}

