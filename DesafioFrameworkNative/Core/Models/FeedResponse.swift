//
//  FeedResponse.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

struct FeedResponse: Decodable {
    let feed: Feed

    struct Feed: Decodable {
        let oferta: String?
        let falkor: Falkor?
    }

    struct Falkor: Decodable {
        let nextPage: Int?
    }
}
