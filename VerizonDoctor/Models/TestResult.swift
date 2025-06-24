//
//  TestResult.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation

struct TestResult: Identifiable {
    let id: UUID
    let result: Bool
    let testCase: TestCase
    var summary: String?
    var details: String?
    var output: [String: String]?
    var timestamp: Date
    var duration: TimeInterval?
    var metadata: [String: Any]?

    init(
        result: Bool,
        testCase: TestCase,
        summary: String = "",
        details: String? = nil,
        output: [String: String]? = nil,
        timestamp: Date = Date(),
        duration: TimeInterval? = nil,
        metadata: [String: Any]? = nil,
        id: UUID = UUID()
    ) {
        self.testCase = testCase
        self.result = result
        self.summary = summary
        self.details = details
        self.output = output
        self.timestamp = timestamp
        self.duration = duration
        self.metadata = metadata
        self.id = id
    }
}
