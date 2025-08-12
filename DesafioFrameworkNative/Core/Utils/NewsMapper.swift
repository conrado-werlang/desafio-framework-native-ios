//
//  NewsMapper.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

protocol NewsMapping {
    func map(_ dict: [String: Any]) -> News?
    func filterAllowedTypes(_ items: [News]) -> [News]
}

struct NewsMapper: NewsMapping {
    func map(_ dict: [String: Any]) -> News? {
        let type = (dict["type"] as? String)?.lowercased()
        let metadataText = dict["metadata"] as? String
        guard let id = dict["id"] as? String else { return nil }
        guard let content = dict["content"] as? [String: Any] else { return nil }

        let title = string(in: content, keys: ["title", "headline", "shortTitle"])
        let url   = string(in: content, keys: ["url", "canonicalUrl", "href", "link"])
        if title == nil && url == nil { return nil }

        var chapeu: String?
        if let chapeuDict = content["chapeu"] as? [String: Any] {
            chapeu = string(in: chapeuDict, keys: ["label", "title"])
        }

        let summary = string(in: content, keys: ["summary", "resumo", "description", "descricao"])
        
        let imageUrl = imageURL(from: content)

        return News(
            id: id,
            type: type,
            chapeu: chapeu,
            title: title,
            url: url,
            summary: summary,
            imageUrl: imageUrl,
            metadataText: metadataText
        )
    }

    func filterAllowedTypes(_ items: [News]) -> [News] {
        let allowedTypes: Set<String> = ["basico", "materia"]
        return items.filter { allowedTypes.contains($0.type?.lowercased() ?? "") }
    }

    // MARK: - Helpers
    
    private func string(in dict: [String: Any], keys: [String]) -> String? {
        for k in keys {
            if let value = dict[k] as? String, !value.isEmpty { return value }
        }
        return nil
    }

    private func imageURL(from content: [String: Any]) -> String? {
        guard let image = content["image"] as? [String: Any] else { return nil }

        if let sizes = image["sizes"] as? [String: Any] {
            if let postM = sizes["postM"] as? [String: Any],
               let url = postM["url"] as? String, !url.isEmpty {
                return url
            }
            if let m = sizes["M"] as? [String: Any],
               let url = m["url"] as? String, !url.isEmpty {
                return url
            }
            if let l = sizes["L"] as? [String: Any],
               let url = l["url"] as? String, !url.isEmpty {
                return url
            }
        }

        return image["url"] as? String
    }
}
