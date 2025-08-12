//
//  NewsItemView.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import SwiftUI

struct NewsItemView: View {
    let item: News

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NewsThumbnail(urlString: item.imageUrl)

            if let ch = item.chapeu, !ch.isEmpty {
                Text(ch.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Chapéu: \(ch)")
            }

            Text(item.title ?? "")
                .font(.headline)
                .lineLimit(3)

            if let summary = item.summary, !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            if let metadataText = item.metadataText, !metadataText.isEmpty {
                 Text(metadataText)
                     .font(.caption)
                     .foregroundColor(.secondary)
                     .lineLimit(1)
                     .truncationMode(.tail)
                 .padding(.top, 2)
             }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }
    
    private var accessibilityText: String {
        let parts = [
            item.chapeu,
            item.title,
            item.summary,
            item.metadataText
        ].compactMap { $0 }.joined(separator: ". ")
        return parts.isEmpty ? "Notícia" : parts
    }
}

struct NewsThumbnail: View {
    let urlString: String?
    var height: CGFloat = 180

    var body: some View {
        if let urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: height)
                        .clipped()
                        .cornerRadius(12)
                        .accessibilityHidden(true)

                case .empty, .failure:
                    ThumbnailPlaceholder(height: height)

                @unknown default:
                    ThumbnailPlaceholder(height: height)
                }
            }
        } else {
            ThumbnailPlaceholder(height: height)
        }
    }
}

private struct ThumbnailPlaceholder: View {
    var height: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.primary.opacity(0.08))
            .frame(height: height)
            .overlay(
                Image(systemName: "photo")
                    .imageScale(.large)
                    .opacity(0.3)
            )
            .accessibilityLabel("Imagem indisponível")
    }
}
