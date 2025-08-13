//
//  FeedCacheStore.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

protocol FeedCaching {
    func save(_ cache: CachedFeed) throws
    func load(source: FeedSource) -> CachedFeed?
}

struct FeedCacheStore: FeedCaching {
    private let fm = FileManager.default
    private let dir: URL

    init() {
        let base = fm.urls(for: .cachesDirectory, in: .userDomainMask).first!
        dir = base.appendingPathComponent("FeedCache", isDirectory: true)
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
    }

    func save(_ cache: CachedFeed) throws {
        let url = fileURL(for: cache.source)
        let data = try JSONEncoder().encode(cache)
        try data.write(to: url, options: .atomic)
    }

    func load(source: FeedSource) -> CachedFeed? {
        let url = fileURL(for: source)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(CachedFeed.self, from: data)
    }

    private func fileURL(for source: FeedSource) -> URL {
        dir.appendingPathComponent("\(source.rawValue).json")
    }
}
