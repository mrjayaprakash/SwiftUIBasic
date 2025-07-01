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
  
    // MARK: - Bad Pixel
    
    
    static let badPixelPassSummary = "Screen appears free of pixel defects."

    static let badPixelFailSummary = "Bad or stuck pixels were detected."

    static let badPixelSuccessDetails = "User confirmed the screen displayed all test colors without anomalies."

    static let badPixelFailureDetails = "User reported dead or stuck pixels during the color sweep."
    static let badPixelConfirmPrompt = "Did you notice any dead or stuck pixels?"
    static let badPixelNoIssues = "No Issues"
    static let badPixelIssueFound = "Yes, Issue Found"


    // MARK: - Touch
    
    static let touchPassSummary = "Touch screen is fully responsive."

    static let touchFailSummary = "Touch responsiveness test failed."

    static let touchSuccessDetails = "User successfully interacted with all grid regions."

    static let touchFailureDetails = "Some areas of the screen did not register user input."


    // MARK: - Metadata Keys

    static let sensorTypeKey = "sensorType"

    static let updateIntervalKey = "updateInterval"

    static let permissionGrantedKey = "permissionGranted"

    static let deviceModelKey = "deviceModel"

    static let biometryEnrolledKey = "biometryEnrolled"

    static let torchAvailableKey = "torchAvailable"

    static let testModeKey = "testExecutionMode"
    
    // MARK: - Actions

    static let runTest = "Run Test"
    static let restart = "Restart"
    static let next = "Next"
    static let uploadResults = "Upload to Server"
    static let done = "Done"
    
    // MARK: - Result Labels

    static let testPassed = "Test Passed"
    static let testFailed = "Test Failed"
    static let resultPassSymbol = "✅"
    static let resultFailSymbol = "❌"

}
