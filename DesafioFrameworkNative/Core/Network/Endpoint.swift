//
//  Endpoint.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

enum Endpoint {
    case firstNewsG1
    case firstURI(String)
    case newsPage(oferta: String, page: Int)

    var url: URL {
        switch self {
        case .firstNewsG1:
            return URL(string: "https://native-leon.globo.com/feed/g1")!
        case .firstURI(let uri):
            let urlString = "https://native-leon.globo.com/feed/\(uri)"
            return URL(string: urlString)!
        case .newsPage(let oferta, let page):
            return URL(string: "https://native-leon.globo.com/feed/page/g1/\(oferta)/\(page)")!
        }
    }
    
    static var firstNewsPage: Endpoint { .firstNewsG1 }
    static var firstAgroPage: Endpoint {
        .firstURI("https://g1.globo.com/economia/agronegocios")
    }
}
