//
//  FeedHeaderDecoder.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

struct FeedHeader {
    let oferta: String?
    let nextPage: Int?
}

protocol FeedHeaderDecoding {
    func decodeHeader(from data: Data) throws -> FeedHeader
}

struct FeedHeaderDecoder: FeedHeaderDecoding {
    func decodeHeader(from data: Data) throws -> FeedHeader {
        struct Root: Decodable {
            struct Falkor: Decodable { let nextPage: Int? }
            struct Feed: Decodable { let oferta: String?; let falkor: Falkor? }
            let feed: Feed
        }
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        let root = try dec.decode(Root.self, from: data)
        return .init(oferta: root.feed.oferta, nextPage: root.feed.falkor?.nextPage)
    }
}
