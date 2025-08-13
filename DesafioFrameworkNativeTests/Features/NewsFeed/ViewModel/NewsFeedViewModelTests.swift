//
//  NewsFeedViewModelTests.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 13/08/25.
//

import XCTest
@testable import DesafioFrameworkNative

// MARK: - Mocks/Stubs

final class NewsFeedServiceMock: NewsFeedServicing {
    
    var responses: [(items: [News], oferta: String?, nextPage: Int?)]
    private var index = 0
    
    init(responses: [(items: [News], oferta: String?, nextPage: Int?)]) {
        self.responses = responses
    }
    
    func fetch(source: FeedSource, oferta: String?, page: Int?) async throws
    -> (items: [News], oferta: String?, nextPage: Int?)
    {
        // Devolve a próxima resposta e trava no último índice
        let response = responses[min(index, responses.count - 1)]
        if index < responses.count - 1 { index += 1 }
        return response
    }
}

struct FeedCacheStub: FeedCaching {
    var stored: CachedFeed?
    func save(_ snapshot: CachedFeed) throws {}
    func load(source: FeedSource) -> CachedFeed? { stored }
}

struct FailingNewsFeedService: NewsFeedServicing {
    func fetch(source: FeedSource, oferta: String?, page: Int?) async throws
    -> (items: [News], oferta: String?, nextPage: Int?)
    {
        throw URLError(.notConnectedToInternet)
    }
}

// MARK: - Helpers

extension News {
    static func make(id: String,
                     title: String = "Title",
                     url: String = "https://g1.globo.com/x") -> News {
        .init(id: id,
              type: "materia",
              chapeu: "Chapéu",
              title: title,
              url: url,
              summary: "Resumo",
              imageUrl: nil,
              metadataText: "Meta")
    }
}

// MARK: - Tests

final class NewsFeedViewModelTests: XCTestCase {
    
    @MainActor
    func testLoadFirstPage_success_setsItemsAndLoadedState() async {
        // Given
        let service = NewsFeedServiceMock(responses: [
            (items: [.make(id: "1"), .make(id: "2")], oferta: "OFFER", nextPage: 6)
        ])
        let viewModel = NewsFeedViewModel(source: .g1,
                                          service: service,
                                          cache: FeedCacheStub())
        
        // When
        await viewModel.loadFirstPage()
        
        // Then
        XCTAssertEqual(viewModel.items.map(\.id), ["1", "2"])
    }
    
    @MainActor
    func testLoadNextPage_whenFetchNewItems_appendsUniqueItemsWithoutDuplicates() async {
        // Given
        let service = NewsFeedServiceMock(responses: [
            (items: [.make(id: "1"), .make(id: "2"), .make(id: "3")], oferta: "OFFER", nextPage: 6),
            (items: [.make(id: "3"), .make(id: "4")], oferta: "OFFER", nextPage: 7)
        ])
        let viewModel = NewsFeedViewModel(source: .g1,
                                          service: service,
                                          cache: FeedCacheStub())
        
        await viewModel.loadFirstPage()
        
        // When
        await viewModel.loadNextPageIfNeeded(currentItem: viewModel.items.last)
        
        // Then
        XCTAssertEqual(viewModel.items.map(\.id), ["1", "2", "3", "4"])
    }
    
    @MainActor
    func test_tryToLoadFirstPage_whenServiceFails_shouldLoadFromCache() async {
        // Given
        let cached = CachedFeed(
            source: .g1,
            date: Date(),
            items: [.make(id: "C1"), .make(id: "C2")],
            oferta: "O-CACHED",
            nextPage: 42
        )
        let cache = FeedCacheStub(stored: cached)
        let viewModel = NewsFeedViewModel(
            source: .g1,
            service: FailingNewsFeedService(),
            cache: cache
        )
        
        // When
        await viewModel.loadFirstPage()
        
        // Then
        XCTAssertEqual(viewModel.items.map(\.id), ["C1", "C2"])
    }
}
