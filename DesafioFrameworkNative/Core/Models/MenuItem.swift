//
//  MenuItem.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

struct MenuItem: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let url: String
}

struct MenuPayload: Decodable {
    let menuItems: [MenuItem]
}
