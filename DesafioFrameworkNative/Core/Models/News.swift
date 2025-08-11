//
//  News.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

struct News: Decodable, Identifiable {
    let id = UUID()

    let type: String?
    let chapeu: String?
    let title: String?
    let url: String?
    let summary: String?
    let imageUrl: String?
    let metadata: Metadata?

    private enum CodingKeys: String, CodingKey {
        case type, chapeu, title, url, summary, metadata, image
    }
    private enum ImageKeys: String, CodingKey { case url }

    init(from decoder: Decoder) throws {
        let codingKeys = try decoder.container(keyedBy: CodingKeys.self)
        type = try? codingKeys.decode(String.self, forKey: .type)
        chapeu = try? codingKeys.decode(String.self, forKey: .chapeu)
        title = try? codingKeys.decode(String.self, forKey: .title)
        url = try? codingKeys.decode(String.self, forKey: .url)
        summary = try? codingKeys.decode(String.self, forKey: .summary)
        metadata = try? codingKeys.decode(Metadata.self, forKey: .metadata)

        if let image = try? codingKeys.nestedContainer(keyedBy: ImageKeys.self, forKey: .image),
           let url = try? image.decode(String.self, forKey: .url) {
            imageUrl = url
        } else {
            imageUrl = nil
        }
    }
}
