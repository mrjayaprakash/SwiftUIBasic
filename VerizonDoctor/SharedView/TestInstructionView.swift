//
//  TestInstructionView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 04/07/25.
//

import SwiftUI

struct TestInstructionView: View {
    let title: String
    let steps: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()

            ForEach(steps.indices, id: \.self) { index in
                Text("• \(steps[index])")
                    .font(.body)
            }

            Spacer()
        }
        .padding()
    }
}
