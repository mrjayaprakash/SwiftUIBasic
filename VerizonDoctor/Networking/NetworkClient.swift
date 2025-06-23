//
//  NetworkClient.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 20/06/25.
//

import Foundation

final class NetworkClient: APIService {
    
    static let shared = NetworkClient()
    private init() {}

    func post<T: Encodable, R: Decodable>(data: T, to endpoint: APIEndpoint) async throws -> R {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = try JSONEncoder().encode(data)

        let (responseData, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(R.self, from: responseData)
    }
}
