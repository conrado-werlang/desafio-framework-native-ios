//
//  APIError.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from server"
        case .decoding(let err): return "Decoding error: \(err.localizedDescription)"
        }
    }
}
