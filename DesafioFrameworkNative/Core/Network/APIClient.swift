//
//  APIClient.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

struct APIClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public

    func fetchData(_ url: URL) async throws -> Data {
        let req = makeRequest(url)
        let (data, response) = try await session.data(for: req)
        try validate(response)
        return data
    }

    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let data = try await fetchData(url)
        return try decode(T.self, from: data)
    }

    // MARK: - Helpers

    private func makeRequest(_ url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        req.cachePolicy = .useProtocolCachePolicy
        req.timeoutInterval = 20
        return req
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw APIError.invalidResponse
        }
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
