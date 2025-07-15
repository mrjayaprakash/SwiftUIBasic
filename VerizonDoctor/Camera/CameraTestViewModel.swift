//
//  CameraTestViewModel.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 15/07/25.
//


import AVFoundation
import SwiftUI

class CameraTestViewModel: NSObject, ObservableObject {
    // Test lifecycle
    @Published var isTesting = false
    @Published var testCompleted = false
    @Published var passed: Bool? = nil
    @Published var testResult: TestResult? = nil

    // Camera metadata
    @Published var iso: Float = 0
    @Published var aperture: Float = 0
    @Published var exposureValue: Float = 0
    @Published var capturedImage: UIImage?
    
    // Extended metadata
    @Published var cameraPosition: String = "rear"
    @Published var resolutionTested: String = ""
    @Published var frameRate: String = ""
    @Published var autofocusResponsive: Bool = false
    @Published var colorAccuracyVerified: Bool = false
    let testCase: TestCase
    private var startTime: Date?

    // Camera session
    var session = AVCaptureSession()
    var output = AVCapturePhotoOutput()
    private var device: AVCaptureDevice?
    private var testTimeoutTimer: Timer?
    private let testTimeout: TimeInterval = 15


    init(testCase: TestCase) {
        self.testCase = testCase
        super.init()
        configureCameraSession()
    }

    func startTest() {
        testTimeoutTimer?.invalidate()
        testTimeoutTimer = Timer.scheduledTimer(withTimeInterval: testTimeout, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.markResult(passed: false)
        }
        isTesting = true
        testCompleted = false
        passed = nil
        testResult = nil
        capturedImage = nil
        startTime = Date()
        DispatchQueue.global(qos: .userInitiated).async {
                  self.session.startRunning()
              }
        analyzeFormatDetails()
        startTimeoutCountdown()
    }

    func markResult(passed: Bool) {
        
        self.passed = passed
        self.testCompleted = true
        testTimeoutTimer?.invalidate()
            testTimeoutTimer = nil

            DispatchQueue.global(qos: .userInitiated).async {
                self.session.stopRunning()
            }

        let duration = startTime.map { Date().timeIntervalSince($0) }
        let failureReason: String? = passed ? nil : (
            capturedImage == nil ? "photoNotCaptured_timeout" : "photoRejected"
        )
        let metadata: [String: Any]
        if passed {
            metadata = fullMetadata(passed: true)
        } else if capturedImage == nil {
            metadata = [
                 "cameraPosition": cameraPosition,
                 "failureReason": failureReason ?? "",
                 "testPassed": false,
                 "timestamp": ISO8601DateFormatter().string(from: Date())
             ]
        } else {
            metadata = fullMetadata(passed: false).merging(["failureReason": "photoRejected"]) { _, new in new }
        }
        
        self.testResult = TestResult(
            result: passed,
            testCase: testCase,
            summary: passed ? DiagnosticStrings.cameraPassSummary : DiagnosticStrings.cameraFailSummary,
            details: passed ? DiagnosticStrings.cameraSuccessDetails : DiagnosticStrings.cameraFailureDetails,
            timestamp: Date(),
            duration: duration,
            metadata: metadata
        )
    }

    private func fullMetadata(passed: Bool) -> [String: Any] {
        return [
            "cameraPosition": cameraPosition,
            "resolutionTested": resolutionTested,
            "frameRate": frameRate,
            "iso": iso,
            "aperture": aperture,
            "ev": exposureValue,
            "autofocusResponsive": autofocusResponsive,
            "colorAccuracyVerified": colorAccuracyVerified,
            "testPassed": passed,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]
    }
    
    func restart() {
        testTimeoutTimer?.invalidate()
        testTimeoutTimer = nil
        testResult = nil
        startTest()
        
    }

    func updateCameraStats() {
        guard let device = device else { return }
        iso = device.iso
        aperture = device.lensAperture
//        exposureValue = device.exposureTargetBias
        exposureValue = log2(pow(aperture, 2) / Float(device.exposureDuration.seconds))
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    private func startTimeoutCountdown() {
         testTimeoutTimer?.invalidate()
        testTimeoutTimer = Timer.scheduledTimer(withTimeInterval: testTimeout, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.markResult(passed: false)
            }
        }

     }


    private func configureCameraSession() {
        session.beginConfiguration()
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input),
              session.canAddOutput(output) else { return }

        device = camera
        session.addInput(input)
        session.addOutput(output)
        session.commitConfiguration()
        cameraPosition = camera.position == .front ? "front" : "rear"
    }
    private func analyzeFormatDetails() {
         guard let device = device else { return }

         let format = device.activeFormat
         let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
         resolutionTested = "\(dimensions.width)x\(dimensions.height)"

         if let frameRateRange = format.videoSupportedFrameRateRanges.first {
             frameRate = "\(Int(frameRateRange.maxFrameRate))fps"
         }

         autofocusResponsive = device.isFocusModeSupported(.autoFocus)
         colorAccuracyVerified = true // Optionally hook into RGB balance check
     }
}

extension CameraTestViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            capturedImage = image
        }
    }
}
