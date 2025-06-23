//
//  APIEndpoint.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 20/06/25.
//

import Foundation

enum APIEndpoint {
    case submitResults
    case custom(String)

    var url: URL {
        switch self {
        case .submitResults:
            return URL(string: "https://your-api.com/test-results")!
        case .custom(let path):
            return URL(string: path)!
        }
    }

    var method: String {
        return "POST"
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
}

