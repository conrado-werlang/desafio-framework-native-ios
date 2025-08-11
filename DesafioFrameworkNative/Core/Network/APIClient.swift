//
//  APIClient.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//
import Foundation

struct APIClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        var request = URLRequest(url: url)

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw APIError.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
