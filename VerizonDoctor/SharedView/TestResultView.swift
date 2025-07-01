//
//  TestResultView.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 30/06/25.
//

import SwiftUI

struct TestResultView: View {
    let result: TestResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Result: \(result.result ? "✅ Pass" : "❌ Fail")")
                .font(.headline)
                .foregroundColor(result.result ? .green : .red)

            Text("Start Time: \(DateFormatterUtil.formattedShortDateTime(from: result.timestamp))")

            if let duration = result.duration {
                Text("Duration: \(String(format: "%.2f", duration)) sec")
            }

            if let summary = result.summary {
                Text("Summary: \(summary)")
            }

            if let details = result.details {
                Text("Details: \(details)")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
    }
}


