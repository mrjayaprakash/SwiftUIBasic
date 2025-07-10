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

        // Customize back arrow appearance
        let backImage = UIImage(systemName: "chevron.backward")?
            .withTintColor(.yellow, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        // Remove back button title text
        let backButton = UIBarButtonItemAppearance()
        backButton.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButton

        // Apply globally
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            DiagnosticTabBarView()
        }
    }
    
}
