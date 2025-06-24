//
//  TestResultRequest.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 20/06/25.
//

import Foundation

struct TestResultRequest: Encodable {
    let testName: String
    let result: Bool
    let summary: String?
    let details: String?
    let output: [String: String]?
    let timestamp: String
    let duration: Double?
    let metadata: [String: String]?
    let udid: UUID

    init(from testResult: TestResult) {
        self.testName = testResult.testCase.name
        self.result = testResult.result
        self.summary = testResult.summary
        self.details = testResult.details
        self.output = testResult.output
        self.timestamp = ISO8601DateFormatter().string(from: testResult.timestamp)
        self.duration = testResult.duration
        self.udid = testResult.id

        // Convert metadata [String: Any]? to [String: String]?
        if let metadata = testResult.metadata {
            self.metadata = metadata.mapValues { "\($0)" }
        } else {
            self.metadata = nil
        }
    }
}

//{
//  "id": "9A78F0D2-8C3B-4119-BF59-A1621EF01D56",
//  "result": true,
//  "summary": "Gyroscope is responsive and within expected range.",
//  "details": "Sensor values remain stable under rotation.",
//  "output": {
//    "x": "0.001",
//    "y": "-0.003",
//    "z": "0.000"
//  },
//  "timestamp": "2025-06-23T13:45:00Z",
//  "duration": 1.23,
//  "testType": "gyroscope",
//  "metadata": {
//    "axisStability": "high",
//    "testEnvironment": "calm"
//  }
//}

//{
//  "id": "7C5BD6E3-EF24-4AF9-890B-307F9C9A38F9",
//  "result": false,
//  "summary": "Accelerometer readings are outside normal thresholds.",
//  "details": "Detected persistent bias on Y-axis.",
//  "output": {
//    "x": "0.098",
//    "y": "0.984",
//    "z": "-0.127"
//  },
//  "timestamp": "2025-06-23T13:48:10Z",
//  "duration": 1.65,
//  "testType": "accelerometer",
//  "metadata": {
//    "deviceOrientation": "flat",
//    "gravityExpected": "9.8",
//    "gravityDetected": "10.5"
//  }
//}

//{
//  "id": "2B3DAF10-862B-4E0B-9DB8-6C56BDFD1C1F",
//  "result": true,
//  "summary": "Flashlight turned on and off successfully.",
//  "details": "User confirmed visual flash response.",
//  "output": {
//    "turnOnDelay": "0.12",
//    "turnOffDelay": "0.09"
//  },
//  "timestamp": "2025-06-23T13:57:22Z",
//  "duration": 0.84,
//  "testType": "flashlight",
//  "metadata": {
//    "mode": "white",
//    "intensity": "default"
//  }
//}

