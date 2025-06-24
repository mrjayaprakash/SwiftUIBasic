//
//  GyrocopeView.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import SwiftUI

struct GyrocopeView: View {
    @StateObject private var viewModel: GyrocopeViewModel
    
    init(testcase: TestCase){
        _viewModel = StateObject(wrappedValue: GyrocopeViewModel(testCase: testcase))
    }
    var body: some View {
        VStack {
            Text(viewModel.testCase.name)
                .font(.largeTitle)
                .padding()
            
            Button("Run Test"){
                viewModel.runGyroscopeTest()
            }
            .buttonStyle(.borderedProminent)
            .padding()
//            if let result = viewModel.testResult {
//                Text("Result: \(result.result ? "Pass" : "Fail")")
//                    .font(.headline)
//                    .padding()
//            }
            if let testResult = viewModel.testResult {
                           VStack(alignment: .leading, spacing: 12) {
                               Text("Result: \(testResult.result ? "✅ Pass" : "❌ Fail")")
                                   .font(.headline)
                                   .foregroundColor(testResult.result ? .green : .red)

                               Text("Start Time: \(DateFormatterUtil.formattedShortDateTime(from: testResult.timestamp))")
                               if let duration = testResult.duration {
                                   Text("Duration: \(String(format: "%.2f", duration)) sec")
                               }

                               if let summary = testResult.summary {
                                   Text("Summary: \(summary)")
                               }

                               if let details = testResult.details {
                                   Text("Details: \(details)")
                               }
//                               if let output = testResult.output {
//                                   ForEach(output.sorted { $0.key < $1.key }, id: \.key) { key, value in
//                                       HStack {
//                                           Text("\(key):").bold()
//                                           Spacer()
//                                           Text(value)
//                                       }
//                                   }
//                               }

                           }
                           .padding()
                           .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                       }
            switch viewModel.submissionState {
            case .idle, .cancelled, .retrying:
                EmptyView()
            case .inProgress:
                ProgressView("Uploading...")
            case .success(let message):
                Text("✅ \(message)")
                    .foregroundColor(.green)
                    .font(.subheadline)
            case .failure(let message):
                Text("❌ \(message)")
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
        }
        .navigationTitle(viewModel.testCase.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
