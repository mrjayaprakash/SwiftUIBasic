//
//  HardwareTestManager.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import AVFoundation
import LocalAuthentication

class HardwareTestManager {
    static let shared = HardwareTestManager()
    
    func runFlashlightTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        guard let device = AVCaptureDevice.default(for: .video),
        device.hasTorch else {
            completion(TestResult(result: false, testCase: testCase))
            return
        }
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                device.torchMode = .off
                device.unlockForConfiguration()
                let result = TestResult(result: true, testCase: testCase)
                completion(result)
            }
        } catch {
            completion(TestResult(result: false, testCase: testCase))
        }
    }
    
    func runFaceIDTest(_ testCase: TestCase, completion: @escaping (TestResult) -> Void) {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(TestResult(result: false, testCase: testCase))
            return
        }
        
        guard context.biometryType == .faceID else {
            completion(TestResult(result: false, testCase: testCase))
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Face ID Diagnostic Test") {success, authError in
            DispatchQueue.main.async {
                if success {
                    completion(TestResult(result: true, testCase: testCase))
                } else {
                    let message = authError?.localizedDescription ?? "Face ID Authentication failed"
                    completion(TestResult(result: false, testCase: testCase))
                }
            }
        }
    }
}

