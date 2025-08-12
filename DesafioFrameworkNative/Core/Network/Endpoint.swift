//
//  Endpoint.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

enum Endpoint {
    case firstNewsPage
    case newsPage(oferta: String, page: Int)

    var url: URL {
        switch self {
        case .firstNewsPage:
            return URL(string: "https://native-leon.globo.com/feed/g1")!
        case .newsPage(let oferta, let page):
            return URL(string: "https://native-leon.globo.com/feed/page/g1/\(oferta)/\(page)")!
        }
    }
}
