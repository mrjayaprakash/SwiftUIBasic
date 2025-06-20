//
//  AccelerometerView.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import SwiftUI

struct AccelerometerView: View {
    @StateObject private var viewModel: AccelerometerViewModel
    
    init(testcase: TestCase){
        _viewModel = StateObject(wrappedValue: AccelerometerViewModel(testCase: testcase))
    }
    var body: some View {
        VStack {
            Text(viewModel.testCase.name)
                .font(.largeTitle)
                .padding()
            
            Button("Run Test"){
                viewModel.runAccelerometerTest()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            if let result = viewModel.testResult {
                Text("Result: \(result.result ? "Pass" : "Fail")")
                    .font(.headline)
                    .padding()
            }
        }
        .navigationTitle(viewModel.testCase.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
