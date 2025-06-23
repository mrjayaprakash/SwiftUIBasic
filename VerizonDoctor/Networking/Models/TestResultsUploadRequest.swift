//
//  TestResultsUploadRequest.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 20/06/25.
//

import Foundation

struct TestResultsUploadRequest: Encodable {
    let results: [TestResultRequest]
}
