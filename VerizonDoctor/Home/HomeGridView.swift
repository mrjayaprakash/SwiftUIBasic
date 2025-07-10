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
                    NavigationLink(destination: getTestCaseView(testcase)) {
                        let isSelected = selectedIDs.contains(testcase.id)

                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.black, lineWidth: 1)
                                .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1)

                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(testcase.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 1)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(Color.green)

                                Text(testcase.name)
                                    .font(.system(size: 11))
                                    .foregroundColor(.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.bottom, 12)
                            }
//                            .onTapGesture {
//                                toggleSelection(testcase)
//                            }

                            .padding(.top, 8) // Top padding applied to the entire VStack
                            .padding(.horizontal, 8)
                        }
                        .frame(width: 104, height: 88)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
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
