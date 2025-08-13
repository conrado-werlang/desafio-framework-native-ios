//
//  CachedFeed.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

struct CachedFeed: Codable {
    let source: FeedSource
    let date: Date
    let items: [News]
    let oferta: String?
    let nextPage: Int?
}
