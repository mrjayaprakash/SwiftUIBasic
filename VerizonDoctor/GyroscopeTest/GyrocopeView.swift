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
