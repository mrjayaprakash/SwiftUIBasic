//
//  HomeListView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 25/06/25.
//

import SwiftUI

struct HomeListView: View {
    let testCases: [TestCase]
    let selectedIDs: Set<UUID>
    let toggleSelection: (TestCase) -> Void

    var body: some View {
        List(testCases) { testcase in
            let isSelected = selectedIDs.contains(testcase.id)
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
                toggleSelection(testcase)
            }
        }
    }
}

