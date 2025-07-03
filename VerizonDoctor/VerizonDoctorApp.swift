//
//  VerizonDoctorApp.swift
//  VerizonDoctor
//
//  Created by Jayaprakash M on 17/06/25.
//

import SwiftUI
import SwiftData

@main
struct VerizonDoctorApp: App {
    private let customRed = Color(hex: 0xDB2F2D)

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(customRed)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.yellow]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            DiagnosticTabBarView()
        }
    }
    
}
