//
//  MenuService.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

protocol MenuServicing {
    func fetchMenu() async throws -> [MenuItem]
}

struct MenuService: MenuServicing {
    func fetchMenu() async throws -> [MenuItem] {
        guard let fileURL = Bundle.main.url(forResource: "menu", withExtension: "json") else {
            throw NSError(domain: "MenuService", code: 1, userInfo: [NSLocalizedDescriptionKey: "menu.json not found"])
        }
        let data = try Data(contentsOf: fileURL)
        let payload = try JSONDecoder().decode(MenuPayload.self, from: data)
        return payload.menuItems
    }
}
