//
//  FeedSource.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

enum FeedSource {
    case g1
    case agro

    var firstEndpoint: Endpoint {
        switch self {
        case .g1:   return .firstNewsPage
        case .agro: return .firstAgroPage
        }
    }

    var title: String {
        switch self {
        case .g1: return "Notícias"
        case .agro: return "Agronegócios"
        }
    }
}
