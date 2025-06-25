//
//  HeaderView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 25/06/25.
//

import SwiftUI

enum TestMode: String, CaseIterable, Identifiable {
    case system = "System"
    case hardwar = "Hardware"
    var id: String { rawValue }
}

struct HeaderView: View {
    @Binding var selectedTestMode: TestMode
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text ("MVD Active Tests")
                    .font(.title.bold())
                    .foregroundColor(.yellow)
                Spacer()
                
                HStack(spacing: 16) {
                    
                    Button(action: {
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    Button(action: {
                    }) {
                        Image(systemName: "bubble.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
                
            }
            Picker("Test Mode", selection: $selectedTestMode) {
                ForEach(TestMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
        }
        .padding()
        .background(Color.red)
    }
}

