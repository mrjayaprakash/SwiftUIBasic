//
//  DiagnosticStrings.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 19/06/25.
//

enum DiagnosticStrings {

   

    // MARK: - Gyroscope

    static let gyroPassSummary = "Gyroscope is active."

    static let gyroFailSummary = "Gyroscope test failed."

    static let gyroSuccessDetails = "Motion data detected from Core Motion API."

    static let gyroFailureDetails = "No rotation rate data received from motion manager."

   

    static let gyroOutputX = "rotationRateX"

    static let gyroOutputY = "rotationRateY"

    static let gyroOutputZ = "rotationRateZ"

   

    // MARK: - Accelerometer

    static let accelPassSummary = "Accelerometer is responsive."

    static let accelFailSummary = "Accelerometer test failed."

    static let accelSuccessDetails = "Acceleration data captured successfully."

    static let accelFailureDetails = "Accelerometer unavailable or returned no data."

   

    static let accelOutputX = "accelX"

    static let accelOutputY = "accelY"

    static let accelOutputZ = "accelZ"

   

    // MARK: - Magnetometer

    static let magnetPassSummary = "Magnetometer detected magnetic field."

    static let magnetFailSummary = "Magnetometer test failed."

    static let magnetSuccessDetails = "Magnetic readings retrieved from the sensor."

    static let magnetFailureDetails = "No magnetic field data received or sensor unavailable."

   

    static let magnetOutputX = "fieldX"

    static let magnetOutputY = "fieldY"

    static let magnetOutputZ = "fieldZ"

   

    // MARK: - Flashlight

    static let flashlightPassSummary = "Flashlight turned on."

    static let flashlightFailSummary = "Flashlight test failed."

    static let flashlightSuccessDetails = "Torch was activated and turned off successfully."

    static let flashlightFailureDetails = "Error encountered while enabling torch."

   

    static let torchOutputLevel = "torchLevel"

   

    // MARK: - Face ID

    static let faceIDPassSummary = "Face ID authentication passed."

    static let faceIDFailSummary = "Face ID test failed."

    static let faceIDSuccessDetails = "User authenticated using biometrics successfully."

    static let faceIDFailureDetails = "Biometric authentication unavailable or canceled."

   

    static let faceIDOutputType = "biometryType"

   

    // MARK: - Metadata Keys

    static let sensorTypeKey = "sensorType"

    static let updateIntervalKey = "updateInterval"

    static let permissionGrantedKey = "permissionGranted"

    static let deviceModelKey = "deviceModel"

    static let biometryEnrolledKey = "biometryEnrolled"

    static let torchAvailableKey = "torchAvailable"

    static let testModeKey = "testExecutionMode"

}
