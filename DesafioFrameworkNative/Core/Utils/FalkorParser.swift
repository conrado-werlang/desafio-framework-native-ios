//
//  FalkorParser.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

protocol FalkorParsing {
    func extractItems(from data: Data) throws -> [[String: Any]]
}

struct FalkorParser: FalkorParsing {
    func extractItems(from data: Data) throws -> [[String: Any]] {
        let any = try JSONSerialization.jsonObject(with: data, options: [])
        guard
            let root = any as? [String: Any],
            let feed = root["feed"] as? [String: Any],
            let falkor = feed["falkor"] as? [String: Any],
            let items = falkor["items"] as? [[String: Any]]
        else { return [] }
        return items
    }
}
