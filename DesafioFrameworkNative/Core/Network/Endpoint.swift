//
//  Endpoint.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

enum Endpoint {
    case news(page: Int)

    var url: URL {
        switch self {
        case .news(let page):
            var comps = URLComponents(string: "https://native-leon.globo.com/feed/g1")!
            comps.queryItems = [URLQueryItem(name: "p", value: String(page))]
            return comps.url!
        }
    }
}
