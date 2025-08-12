//
//  MenuViewModel.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

@MainActor
final class MenuViewModel: ObservableObject {
    enum State {
        case loading, loaded, error(String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var items: [MenuItem] = []

    private let service: MenuServicing

    init(service: MenuServicing = MenuService()) {
        self.service = service
    }

    func load() async {
        state = .loading
        do {
            items = try await service.fetchMenu()
            state = .loaded
        } catch {
            state = .error("Falha ao carregar o menu.")
        }
    }

    func reload() async { await load() }
}
