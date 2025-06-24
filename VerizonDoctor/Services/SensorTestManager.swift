//
//  SensorTestManager.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import CoreMotion
import Foundation

protocol SensorTesting {
    func runTest(for testCase: TestCase, completion: @escaping (TestResult) -> Void)
}

final class SensorTestManager: SensorTesting {
    private let motionManager = CMMotionManager()
    
    func runTest(for testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        switch testCase.type {
        case .gyroscope:
            runGyroScopeTest(testCase, completion: completion)
        case .accelerometer:
            runAccelerometerTest(testCase, completion: completion)
        case .magnetoMeter:
            runMagnetoMeterTest(testCase, completion: completion)
        default:
            completion(TestResult(
                    result: false,
                    testCase: testCase
                ))
        }
    }
    
    func runGyroScopeTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        guard motionManager.isGyroAvailable else {
            
            completion(TestResult(result: false,
                                  testCase: testCase,
                                  summary: DiagnosticStrings.gyroFailSummary,
                                  details: DiagnosticStrings.gyroFailureDetails
                                 ))
            return
        }
        motionManager.gyroUpdateInterval = 0.1
        let startTime = Date()
        //var success = false
        motionManager.startGyroUpdates(to: .main) { (data, error) in
            var result: TestResult
            
            if data?.rotationRate != nil {
                let duration = Date().timeIntervalSince(startTime)
                //            if let rotationRate = data?.rotationRate {
                //                let isStable = abs(rotationRate.x) < 0.2 &&
                //                               abs(rotationRate.y) < 0.2 &&
                //                               abs(rotationRate.z) < 0.2
                //                success = !isStable
                result = TestResult(result: true, testCase: testCase,
                                    summary: DiagnosticStrings.gyroPassSummary,
                                    details: DiagnosticStrings.gyroSuccessDetails,
                                    output: [
                                        DiagnosticStrings.gyroOutputX: String(format: "%.3f", data?.rotationRate.x ?? ""),
                                        DiagnosticStrings.gyroOutputY: String(format: "%.3f", data?.rotationRate.y ?? ""),
                                        DiagnosticStrings.gyroOutputZ: String(format: "%.3f", data?.rotationRate.z ?? ""),
                                    ],
                                    timestamp: Date(),
                                    duration: duration,
                                    metadata: [
                                        DiagnosticStrings.sensorTypeKey: "CMGyroData",
                                        DiagnosticStrings.updateIntervalKey: "\(self.motionManager.gyroUpdateInterval)",
                                    ])
                
            } else {
                result = TestResult(result: false,
                                    testCase: testCase,
                                    summary: DiagnosticStrings.gyroFailSummary,
                                    details: DiagnosticStrings.gyroFailureDetails
                )
            }
            self.motionManager.stopGyroUpdates()
            completion(result)
        }
    }
    
    // MARK: - Accelerometer
    func runAccelerometerTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        guard motionManager.isAccelerometerAvailable else {
            completion(TestResult(result: false,
                                  testCase: testCase,
                                  summary: DiagnosticStrings.accelFailSummary,
                                  details: DiagnosticStrings.accelFailureDetails))
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        let startTime = Date()
        
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self else { return }
            self.motionManager.stopAccelerometerUpdates()
            
            let duration = Date().timeIntervalSince(startTime)
            
            if let accel = data?.acceleration {
                let result = TestResult(
                    result: true,
                    testCase: testCase,
                    summary: DiagnosticStrings.accelPassSummary,
                    details: DiagnosticStrings.accelSuccessDetails,
                    output: [
                        "x": String(format: "%.3f", accel.x),
                        "y": String(format: "%.3f", accel.y),
                        "z": String(format: "%.3f", accel.z)
                    ],
                    timestamp: Date(),
                    duration: duration,
                    metadata: [
                        DiagnosticStrings.sensorTypeKey: "CMAccelerometerData",
                        DiagnosticStrings.updateIntervalKey: "\(self.motionManager.accelerometerUpdateInterval)"
                    ]
                )
                completion(result)
            } else {
                completion(TestResult(result: false,
                                      testCase: testCase,
                                        summary: DiagnosticStrings.accelFailSummary,
                                        details: DiagnosticStrings.accelFailureDetails))
            }
        }
    }
    
    // MARK: - Magnetometer
    func runMagnetoMeterTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        guard motionManager.isMagnetometerAvailable else {
            completion(TestResult(result: false,
                                  testCase: testCase,
                                    summary: DiagnosticStrings.magnetFailSummary,
                                    details: DiagnosticStrings.magnetFailureDetails))
            return
        }
        
        motionManager.magnetometerUpdateInterval = 0.1
        let startTime = Date()
        
        motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, _ in
            guard let self else { return }
            self.motionManager.stopMagnetometerUpdates()
            
            let duration = Date().timeIntervalSince(startTime)
            
            if let field = data?.magneticField {
                let result = TestResult(
                    result: true,
                    testCase: testCase,
                    summary: DiagnosticStrings.magnetPassSummary,
                    details: DiagnosticStrings.magnetSuccessDetails,
                    output: [
                        "x": String(format: "%.1f", field.x),
                        "y": String(format: "%.1f", field.y),
                        "z": String(format: "%.1f", field.z)
                    ],
                    timestamp: Date(),
                    duration: duration,
                    metadata: [
                        DiagnosticStrings.sensorTypeKey: "CMMagnetometerData",
                        DiagnosticStrings.updateIntervalKey: "\(self.motionManager.magnetometerUpdateInterval)"
                    ]
                )
                completion(result)
            } else {
                completion(TestResult(result: false,
                                      testCase: testCase,
                                        summary: DiagnosticStrings.magnetFailSummary,
                                        details: DiagnosticStrings.magnetFailureDetails))
            }
        }
    }
}

