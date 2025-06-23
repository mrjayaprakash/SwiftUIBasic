//
//  APIService.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 20/06/25.
//

import Foundation

protocol APIService {
    func post<T: Encodable, R: Decodable>(data: T, to endpoint: APIEndpoint) async throws -> R
}
