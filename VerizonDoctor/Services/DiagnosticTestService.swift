//
//  DiagnosticTestService.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
final class DiagnosticTestService {
//    static let shared = DiagnosticTestService()
    private let sensorTester: SensorTesting
    private let hardwareTester: HardwareTesting

      init(sensorTester: SensorTesting = SensorTestManager(),
           hardwareTester: HardwareTesting = HardwareTestManager()) {
          self.sensorTester = sensorTester
          self.hardwareTester = hardwareTester
      }
    
    func executeTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        switch testCase.category {
        case .sensor:
            sensorTester.runTest(for: testCase, completion: completion)
        case .hardware:
            hardwareTester.runTest(for: testCase, completion: completion)
        }
    }
}
