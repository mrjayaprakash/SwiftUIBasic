//
//  DiagnosticTestService.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
class DiagnosticTestService {
    static let shared = DiagnosticTestService()
    
//    func executeTest(_ testCase: TestCase) -> TestResult {
    func executeTest(_ testCase: TestCase, completion: @escaping(TestResult) -> Void) {
        switch testCase.type {
        case .gyroscope:
            return SensorTestManager.shared.runGyroScopeTest(testCase, completion: completion)
        case .accelerometer:
            return SensorTestManager.shared.runAccelerometerTest(testCase, completion: completion)
        case .magnetoMeter:
            return SensorTestManager.shared.runMagnetoMeterTest(testCase, completion: completion)
        case .speaker:
            return SensorTestManager.shared.runGyroScopeTest(testCase, completion: completion)
        case .camera:
            return SensorTestManager.shared.runGyroScopeTest(testCase, completion: completion)
        case .flashlight:
            return HardwareTestManager.shared.runFlashlightTest(testCase, completion: completion)
        case .faceID:
            return HardwareTestManager.shared.runFaceIDTest(testCase, completion: completion)
        }
    }
}
