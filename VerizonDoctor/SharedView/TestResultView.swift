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
        ScrollView {
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
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                //  Show output values if present
                if let output = result.output, !output.isEmpty {
                    Divider()
                    Text("Output:")
                        .font(.headline)
                    ForEach(output.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Text("\(key): \(value)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                //  Show metadata values if present
                if let metadata = result.metadata, !metadata.isEmpty {
                    Divider()
                    Text("Metadata:")
                        .font(.headline)
                    ForEach(metadata.sorted(by: { "\($0.key)" < "\($1.key)" }), id: \.key) { key, value in
                        Text("\(key): \(String(describing: value))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        }
    }
}
