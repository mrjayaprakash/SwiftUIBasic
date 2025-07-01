//
//  HomeViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import Foundation

enum ResultSubmissionState : Equatable {
    case idle
    case inProgress
    case retrying(attempt: Int)
    case cancelled
    case success(message: String)
    case failure(message: String)
}

class HomeViewModel: ObservableObject {
    @Published var testCases: [TestCase] = [
        TestCase(name: "Gyroscope", description: "Checks gyroscopep functionality", icon: "33", type: .gyroscope),
        TestCase(name: "Accelorometer", description: "Verifiyes accelerometer data", icon: "4", type: .accelerometer),
        TestCase(name: "MagnetoMeter", description: "Verifiyes MagnetoMeter data", icon: "5", type: .magnetoMeter),
        TestCase(name: "Speaker", description: "Checks speaker sound output", icon: "27", type: .speaker),
        TestCase(name: "Camera", description: "Ensure camera operates correctly", icon: "19", type: .camera),
        TestCase(name: "FlashLight", description: "Verifiyes flash light  functionality", icon: "16", type: .flashlight),
        TestCase(name: "Face ID Test", description: "Authenticates using Face ID", icon: "55", type: .faceID),
        TestCase(name: "Touch Screen Test",description: "Checks screen responsiveness by requiring the user to tap or swipe across grid cells", icon: "18", type: .touchScreen),
        TestCase(
            name: "Bad Pixel Test",
            description: "Cycles through solid colors to help visually detect dead or stuck pixels on the screen",
            icon: "55",
            type: .badPixel
        )
    ]
    
    @Published var searchText: String = ""
    @Published var selectedTestIDs: Set<UUID> = []
    @Published var testResults: [TestResult] = []
    private let testService: DiagnosticTestService

    var filteredTestCases: [TestCase] {
        if searchText.isEmpty {
            return testCases
        } else {
            return testCases.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var selectedTests: [TestCase] {
        filteredTestCases.filter { selectedTestIDs.contains($0.id) }
    }
    
    init(testService: DiagnosticTestService = DiagnosticTestService()) {
        self.testService = testService
    }
    
    func toggleSelection(for testCase: TestCase) {
        if selectedTestIDs.contains(testCase.id) {
            selectedTestIDs.remove(testCase.id)
        } else {
            selectedTestIDs.insert(testCase.id)
        }
    }
    
    func runSelectedTests(completion: @escaping () -> Void) {
        testResults.removeAll()
        let group = DispatchGroup()
        var results: [TestResult] = []

        for test in selectedTests {
            group.enter()
            testService.executeTest(test) { result in
                DispatchQueue.main.async {
                    results.append(result)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.testResults = results
            completion()
        }
    }
}
