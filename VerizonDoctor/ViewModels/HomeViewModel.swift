//
//  HomeViewModel.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import Foundation
class HomeViewModel: ObservableObject {
    @Published var testCases: [TestCase] = [
        TestCase(name: "Gyroscope", description: "Checks gyroscopep functionality", icon: "33", type: .gyroscope),
        TestCase(name: "Accelorometer", description: "Verifiyes accelerometer data", icon: "4", type: .accelerometer),
        TestCase(name: "MagnetoMeter", description: "Verifiyes MagnetoMeter data", icon: "5", type: .magnetoMeter),
        TestCase(name: "Speaker", description: "Checks speaker sound output", icon: "27", type: .speaker),
        TestCase(name: "Camera", description: "Ensure camera operates correctly", icon: "19", type: .camera),
        TestCase(name: "FlashLight", description: "Verifiyes flash light  functionality", icon: "16", type: .flashlight),
        TestCase(name: "Face ID Test", description: "Authenticates using Face ID", icon: "55", type: .faceID)
    ]
    
    @Published var searchText: String = ""
    var filteredTestCases: [TestCase] {
        if searchText.isEmpty {
            return testCases
        } else {
            return testCases.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
