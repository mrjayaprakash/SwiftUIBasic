//
//  TestResultSummaryView.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import SwiftUI

struct TestResultSummaryView: View {
    @StateObject var viewModel: TestResultSummaryViewModel

    var body: some View {
        VStack {
            List(viewModel.testResults) { result in
                HStack {
                    Text("Test")
                    Text(result.testCase.name)
                    Spacer()
                    Text(result.result ? "✅ Passed" : "❌ Failed")
                        .foregroundColor(result.result ? .green : .red)
                }
            }

            switch viewModel.submissionState {
            case .success(let msg):
                Text(msg).foregroundColor(.green)
            case .failure(let msg):
                Text(msg).foregroundColor(.red)
            case .inProgress:
                ProgressView("Uploading...")
            default:
                EmptyView()
            }

            Button("Upload to Server") {
                Task {
                    await viewModel.uploadResultsToServer()
                }
            }
            .disabled(viewModel.submissionState == .inProgress)
        }
        .padding()

        }

    }
    
