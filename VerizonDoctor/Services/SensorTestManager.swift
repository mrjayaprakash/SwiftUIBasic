//
//  SensorTestManager.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import CoreMotion
import Foundation
class SensorTestManager {
    static let shared = SensorTestManager()
    private let motionMangaer = CMMotionManager()
    
    func runGyroScopeTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        guard motionMangaer.isGyroAvailable else {
            
            completion(TestResult(result: false, testCase: testCase))
            return
        }
        motionMangaer.gyroUpdateInterval = 0.1
        let startTime = Date()
        //var success = false
        motionMangaer.startGyroUpdates(to: .main) { (data, error) in
            var result: TestResult
            
            if data?.rotationRate != nil {
                let duration = Date().timeIntervalSince(startTime)
//            if let rotationRate = data?.rotationRate {
//                let isStable = abs(rotationRate.x) < 0.2 &&
//                               abs(rotationRate.y) < 0.2 &&
//                               abs(rotationRate.z) < 0.2
//                success = !isStable
                result = TestResult(result: false, testCase: testCase,
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
                            DiagnosticStrings.updateIntervalKey: "\(self.motionMangaer.gyroUpdateInterval)",
                           ])

//                result = TestResult(result: true, testcase: testCase)
            } else {
                result = TestResult(result: false, testCase: testCase)
            }
            self.motionMangaer.stopGyroUpdates()
            completion(result)
        }
    }
    
    func runAccelerometerTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        guard motionMangaer.isAccelerometerAvailable else {
            completion(TestResult(result: false, testCase: testCase))
            return
        }
        motionMangaer.accelerometerUpdateInterval = 0.1
        //var success = false
        motionMangaer.startAccelerometerUpdates(to: .main) { (data, error) in
            var result: TestResult
            
            if data?.acceleration != nil {
                result = TestResult(result: true, testCase: testCase)
            } else {
                result = TestResult(result: false, testCase: testCase)
            }
            self.motionMangaer.stopAccelerometerUpdates()
            completion(result)
        }
    }
    
    func runMagnetoMeterTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        guard motionMangaer.isMagnetometerAvailable else {
            completion(TestResult(result: false, testCase: testCase))
            return
        }
        motionMangaer.magnetometerUpdateInterval = 0.1
        //var success = false
        motionMangaer.startMagnetometerUpdates(to: .main) { (data, error) in
            var result: TestResult
            
            if data?.magneticField != nil {
                result = TestResult(result: true, testCase: testCase)
            } else {
                result = TestResult(result: false, testCase: testCase)
            }
            self.motionMangaer.stopMagnetometerUpdates()
            completion(result)
        }
    }
}

