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

    private let source: FeedSource
    private var oferta: String?
    private var nextPage: Int?
    private var loadedPages = Set<Int>()
    private let service: NewsFeedServicing

    init(source: FeedSource,
         service: NewsFeedServicing = NewsFeedService()) {
        self.source = source
        self.service = service
    }

    func loadFirstPage() async {
        state = .loading
        resetPaging()

        do {
            let response = try await service.fetch(source: source,
                                                   oferta: nil,
                                                   page: nil)
            self.items = response.items
            self.oferta = response.oferta
            self.nextPage = response.nextPage
            self.state = .loaded
        } catch {
            self.state = .error("Falha ao carregar notícias.")
        }
    }

    func reload() async { await loadFirstPage() }

    func loadNextPageIfNeeded(currentItem: News?) async {
        guard case .loaded = state, !isLoadingNextPage else { return }
        guard let currentItem,
              let index = items.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let threshold = max(items.count - 5, 0)
        guard index >= threshold else { return }
        guard let oferta,
                let page = nextPage,
                !loadedPages.contains(page) else { return }

        isLoadingNextPage = true
        loadedPages.insert(page)

        do {
            let response = try await service.fetch(source: source,
                                                   oferta: oferta,
                                                   page: page)
            self.items.append(contentsOf: response.items)
            self.nextPage = response.nextPage
        } catch {

        }
        isLoadingNextPage = false
    }

    private func resetPaging() {
        items.removeAll()
        isLoadingNextPage = false
        oferta = nil
        nextPage = nil
        loadedPages.removeAll()
    }
}
