//
//  ImageLoader.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 13/08/25.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private static let cache = NSCache<NSURL, UIImage>()
    private var url: URL?

    func load(from url: URL) {
        self.url = url
        
        if let cached = Self.cache.object(forKey: url as NSURL) {
            self.image = cached
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let img = UIImage(data: data) {
                    // Salva no cache
                    Self.cache.setObject(img, forKey: url as NSURL)
                    
                    await MainActor.run {
                        if self.url == url {
                            self.image = img
                        }
                    }
                }
            } catch { }
        }
    }
}
