//
//  HeaderView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 25/06/25.
//

import SwiftUI

enum TestMode: String, CaseIterable, Identifiable {
    case system = "Overview"
    case hardwar = "History"
    var id: String { rawValue }
}

struct HeaderView: View {
    @Binding var selectedTestMode: TestMode
    @Binding var selectedCategory: String
    private let categories: [String] = [
        "All test",
        "Audio, microphone, headset",
        "Bluetooth/Wifi",
        "Camera",
        "Display, Touch",
        "GPS and Sensors"
    ]
    private let customRed = Color(hex: 0xDB2F2D)

    var body: some View {
        VStack(spacing: 0) {
            //  Top Bar Section
            VStack {
                HStack {
                    Button(action: {
                        // Handle back action
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }

                    Spacer()

                    Text(DiagnosticStrings.hardwareTestTitle)
                        .font(.headline)
                        .foregroundColor(.yellow)

                    Spacer()

                    HStack(spacing: 16) {
                        Button(action: {
                            // Search action
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                        }

                        Button(action: {
                            // Chat action
                        }) {
                            Image(systemName: "bubble.left")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)
            }
            .background(customRed)

            // ⚪ Control Section
            VStack(alignment: .leading, spacing: 16) {
                // Segmented Control
//                Picker("", selection: $selectedTestMode) {
//                    ForEach(TestMode.allCases) { mode in
//                        Text(mode.rawValue).tag(mode)
//                    }
//                }
//                .pickerStyle(.segmented)
//                .padding(.horizontal, 16)
                
                CustomSegmentedControl(selectedMode: $selectedTestMode)

                // Category Label + Dropdown Menu
                VStack(alignment: .leading, spacing: 4) {
                    Text(DiagnosticStrings.categoriesText)
                        .foregroundColor(.primary)
                        .font(.subheadline)

                    Menu {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedCategory)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4))
                        )
                        .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .background(Color(.systemBackground))
        }
    }
}
