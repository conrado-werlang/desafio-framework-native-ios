//
//  NewsFeedViewModel.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

@MainActor
final class NewsFeedViewModel: ObservableObject {
    enum State { case loading, loaded, error(String) }

    @Published private(set) var state: State = .loading
    @Published private(set) var items: [News] = []
    @Published private(set) var isLoadingNextPage = false

    private var currentPage: Int?
    private var oferta: String?
    private var loadingPages: Set<Int> = []
    private var seenIDs: Set<String> = []

    private let source: FeedSource
    private let service: NewsFeedServicing
    private let cache: FeedCaching

    init(source: FeedSource,
         service: NewsFeedServicing = NewsFeedService(),
         cache: FeedCaching = FeedCacheStore()) {
        self.source = source
        self.service = service
        self.cache = cache
    }

    func loadFirstPage() async {
        state = .loading
        items.removeAll()
        oferta = nil
        currentPage = nil
        loadingPages.removeAll()
        seenIDs.removeAll()
        isLoadingNextPage = false

        do {
            let response = try await service.fetch(source: source,
                                                   oferta: nil,
                                                   page: nil)
            appendUnique(response.items)
            oferta = response.oferta
            currentPage = response.nextPage.map { $0 - 1 }
            state = .loaded

            let snapshot = CachedFeed(source: source, date: Date(),
                                      items: items,
                                      oferta: oferta,
                                      nextPage: response.nextPage)
            try? cache.save(snapshot)

        } catch {
            if let cached = cache.load(source: source) {
                appendUnique(cached.items)
                oferta = cached.oferta
                currentPage = cached.nextPage.map { $0 - 1 }
                state = .loaded
            } else {
                state = .error("Falha ao carregar notícias.")
            }
        }
    }

    func reload() async { await loadFirstPage() }

    func loadNextPageIfNeeded(currentItem: News?) async {
        guard case .loaded = state, !isLoadingNextPage else { return }
        guard let currentItem,
              let index = items.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let threshold = max(items.count - 5, 0)
        guard index >= threshold else { return }

        await loadNextPage()
    }

    private func loadNextPage() async {
        guard let oferta else { return }
        let next = (currentPage ?? 0) + 1
        guard !loadingPages.contains(next) else { return }
        loadingPages.insert(next)
        isLoadingNextPage = true

        defer {
            isLoadingNextPage = false
        }

        do {
            let result = try await service.fetch(source: source, oferta: oferta, page: next)
            appendUnique(result.items)
            self.oferta = result.oferta ?? oferta
            currentPage = next

            let snapshot = CachedFeed(source: source, date: Date(),
                                      items: items, oferta: oferta, nextPage: result.nextPage)
            try? cache.save(snapshot)
        } catch { }
    }

    private func appendUnique(_ newItems: [News]) {
        let filtered = newItems.filter { seenIDs.insert($0.id).inserted }
        items.append(contentsOf: filtered)
    }
}
