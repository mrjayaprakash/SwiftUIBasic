//
//  TestCase.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import Foundation

struct TestCase: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let type: TestType
}
