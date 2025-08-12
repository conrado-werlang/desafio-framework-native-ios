//
//  NewsFeedService.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

protocol NewsFeedServicing {
    func fetch(oferta: String?, page: Int?) async throws -> (items: [News], oferta: String?, nextPage: Int?)
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

    func fetch(oferta: String?, page: Int?) async throws -> (items: [News], oferta: String?, nextPage: Int?) {
        let url = getUrl(oferta, page)
        let first = try await fetchAndParse(url)

        if oferta == nil,
           page == nil,
           first.items.isEmpty,
           let nextOferta = first.header.oferta,
           let nextPage = first.header.nextPage
        {
            let fallbackResult = try await fetchAndParse(
                getUrl(nextOferta, nextPage)
            )
            return (fallbackResult.items, nextOferta, fallbackResult.header.nextPage)
        }

        return (first.items, first.header.oferta, first.header.nextPage)
    }

    // MARK: - Helpers

    private func fetchAndParse(_ url: URL) async throws -> (items: [News], header: FeedHeader) {
        let data = try await api.fetchData(url)
        let header = try headerDecoder.decodeHeader(from: data)
        let dictItems = try falkorParser.extractItems(from: data)
        let mapped = dictItems.compactMap(mapper.map)
        let filtered = mapper.filterAllowedTypes(mapped)
        return (filtered, header)
    }

    func getUrl(_ oferta: String?, _ page: Int?) -> URL {
        guard let oferta, let page else {
            return Endpoint.firstNewsPage.url
        }
        return Endpoint.newsPage(oferta: oferta, page: page).url
    }
}
