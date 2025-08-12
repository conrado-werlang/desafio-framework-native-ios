//
//  APIClient.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

struct APIClient {
    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        try Self.validate(response: response)
        return try Self.decode(T.self, from: data)
    }

    func fetchData(_ url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        try Self.validate(response: response)
        return data
    }

    // MARK: - Helpers (estáticos, usados pelo Service)

    static func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw APIError.invalidResponse
        }
    }

    static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
