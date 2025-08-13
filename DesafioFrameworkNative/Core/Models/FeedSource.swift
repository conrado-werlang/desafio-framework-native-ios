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

    // Como montar a primeira chamada do feed
    enum FirstEntry {
        case feedPath(String)   // exemplo: "g1"  -> /feed/g1
        case webURL(String)     // exemplo: "https://g1.globo.com/economia/agronegocios" (vai encoded no path)
    }

    /// Endpoint base (primeira página) por source
    var firstEntry: FirstEntry {
        switch self {
        case .g1:
            return .feedPath("g1")
        case .agro:
            // Agro usa URL absoluta do site como path
            return .webURL("https://g1.globo.com/economia/agronegocios")
        }
    }

    /// Slug usado na rota de paginação `/feed/page/<slug>/<oferta>/<page>`
    var pageSlug: String {
        switch self {
        case .g1:
            return "g1"
        case .agro:
            // A paginação do Agro também bate em /page/g1/...
            return "g1"
        }
    }

    var title: String {
        switch self {
        case .g1:   return "Notícias"
        case .agro: return "Agronegócio"
        }
    }
}
