//
//  NewsFeedService.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

protocol NewsFeedServicing {
    func fetch(page: Int) async throws -> FeedResponse
}

struct NewsFeedService: NewsFeedServicing {
    private let api: APIClient

    init(api: APIClient = APIClient()) {
        self.api = api
    }

    func fetch(page: Int) async throws -> FeedResponse {
        let url = Endpoint.news(page: page).url
        var response: FeedResponse = try await api.fetch(url)

        if let items = response.items {
            let filtered = items.filter { news in
                let type = news.type?.lowercased() ?? ""
                return type == "basico" || type == "materia"
            }
            response = FeedResponse(items: filtered, nextPage: response.nextPage)
        }

        return response
    }
}
