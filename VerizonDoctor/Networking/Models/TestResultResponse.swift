//
//  TestResultResponse.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 20/06/25.
//

import Foundation

struct TestResultResponse: Codable {
    let status: String        // e.g., "success"
    let message: String?      // e.g., "Result saved"
    let referenceId: String?  // Optional server-generated ID
}
