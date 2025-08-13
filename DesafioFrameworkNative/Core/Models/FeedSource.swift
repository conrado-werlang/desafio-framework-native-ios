//
//  FeedSource.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

enum FeedSource: String, Codable {
    case g1
    case agro

    enum FirstEntry {
        case feedPath(String)
        case webURL(String)
    }

    var firstEntry: FirstEntry {
        switch self {
        case .g1:
            return .feedPath("g1")
        case .agro:
            return .webURL("https://g1.globo.com/economia/agronegocios")
        }
    }

    var product: String {
        return "g1"
    }

    var title: String {
        switch self {
        case .g1:   return "Notícias"
        case .agro: return "Agronegócio"
        }
    }
}
