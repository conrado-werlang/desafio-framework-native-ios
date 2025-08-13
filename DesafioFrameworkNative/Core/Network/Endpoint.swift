//
//  Endpoint.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

enum Endpoint {
    case first(FeedSource)
    case page(FeedSource, oferta: String, page: Int)

    private var baseURL: URL {
        URL(string: "https://native-leon.globo.com/feed")!
    }

    var url: URL {
        switch self {
        case .first(let source):
            switch source.firstEntry {
            case .feedPath(let path):
                return baseURL.appendingPathComponent(path)
            case .webURL(let webUrl):
                return baseURL.appendingPathComponent(webUrl)
            }
        case .page(let source, let oferta, let page):
            return baseURL
                .appendingPathComponent("page")
                .appendingPathComponent(source.product)
                .appendingPathComponent(oferta)
                .appendingPathComponent(String(page))
        }
    }
}
