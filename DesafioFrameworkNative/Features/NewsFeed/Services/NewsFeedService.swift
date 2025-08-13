//
//  NewsFeedService.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

protocol NewsFeedServicing {
    func fetch(source: FeedSource, oferta: String?, page: Int?) async throws
    -> (items: [News], oferta: String?, nextPage: Int?)
}

struct NewsFeedService: NewsFeedServicing {
    private let api: APIClient
    private let headerDecoder: FeedHeaderDecoding
    private let falkorParser: FalkorParsing
    private let mapper: NewsMapping
    
    init(api: APIClient = .init(),
         headerDecoder: FeedHeaderDecoding = FeedHeaderDecoder(),
         falkorParser: FalkorParsing = FalkorParser(),
         mapper: NewsMapping = NewsMapper()) {
        self.api = api
        self.headerDecoder = headerDecoder
        self.falkorParser = falkorParser
        self.mapper = mapper
    }
    
    // MARK: - Public
    
    func fetch(source: FeedSource, oferta: String?, page: Int?) async throws
    -> (items: [News], oferta: String?, nextPage: Int?) {
        let url = makeURL(for: source, oferta: oferta, page: page)
        let parsed = try await fetchAndParse(from: url)
        return (parsed.items, parsed.header.oferta, parsed.header.nextPage)
    }
    
    // MARK: - Helpers
    
    private func fetchAndParse(from url: URL) async throws -> (items: [News], header: FeedHeader) {
        let data = try await api.fetchData(url)
        let header = try headerDecoder.decodeHeader(from: data)
        let dictItems = try falkorParser.extractItems(from: data)
        let mapped = dictItems.compactMap(mapper.map)
        let filtered = mapper.filterAllowedTypes(mapped)
        return (filtered, header)
    }
    
    private func makeURL(for source: FeedSource, oferta: String?, page: Int?) -> URL {
        if let oferta, let page {
            return Endpoint.page(source, oferta: oferta, page: page).url
        } else {
            return Endpoint.first(source).url
        }
    }
}
