//
//  News.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

struct News: Identifiable, Codable {
    let id: String
    let type: String?
    let chapeu: String?
    let title: String?
    let url: String?
    let summary: String?
    let imageUrl: String?
    let metadataText: String?
}
