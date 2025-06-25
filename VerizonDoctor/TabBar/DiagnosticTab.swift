//
//  DiagnosticTab.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 25/06/25.
//

import Foundation

enum DiagnosticTab: String, CaseIterable {
    case home, device, results, shop, support

    var title: String {
        switch self {
        case .home: return "Home"
        case .device: return "Mobile"
        case .results: return "Me"
        case .shop: return "Shop"
        case .support: return "Support"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house"
        case .device: return "iphone"
        case .results: return "person.crop.circle"
        case .shop: return "bag"
        case .support: return "questionmark.circle"
        }
    }
}
