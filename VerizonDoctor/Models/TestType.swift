//
//  TestType.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 18/06/25.
//

import Foundation
enum TestType: String, CaseIterable {
    case gyroscope = "Gyroscope"
    case accelerometer = "Accelerometer"
    case magnetoMeter = "MagnetoMeter"
    case speaker = "Speaker"
    case camera = "Camera"
    case flashlight = "FlashLight"
    case faceID = "FaceID"
    case touchScreen = "TochScreen"
    case badPixel = "badPixel"
    case multiTouch = "multiTouch"
}

enum TestCategory {
    case sensor
    case hardware
}

extension TestType {
    var category: TestCategory {
        switch self {
        case .gyroscope, .accelerometer, .magnetoMeter:
            return .sensor
        case .speaker, .camera, .flashlight, .touchScreen, .multiTouch, .badPixel, .faceID:
            return .hardware
        }
    }
}

