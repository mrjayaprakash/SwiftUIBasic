//
//  HomeGridView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 25/06/25.
//

import SwiftUI

struct HomeGridView: View {
    let testCases: [TestCase]
    let columns: [GridItem]
    let selectedIDs: Set<UUID>
    let getTestCaseView: (TestCase) -> AnyView
    let toggleSelection: (TestCase) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(testCases) { testcase in
//                    NavigationLink(destination: getTestCaseView(testcase)) {
                        let isSelected = selectedIDs.contains(testcase.id)
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(testcase.name)
                                .font(.headline)
                            Text("subtitle")
                                .font(.subheadline)
                        }
                        HStack {
                            Image(testcase.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            
                            Spacer()
                            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        
                    }
                    .onTapGesture {
                        toggleSelection(testcase)
                    }
                        .padding()
                        .frame(width: 110, height: 140)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
//                                            .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                        )
//                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}
/*struct HomeGridView: View {
    let testCases: [TestCase]
    let columns: [GridItem]
    let getTestCaseView: (TestCase) -> AnyView

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(testCases) { testcase in
                    NavigationLink(destination: getTestCaseView(testcase)) {
                        VStack {
                            Image(testcase.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text(testcase.name)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 100, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}
*/
