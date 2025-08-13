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
            chapeuView
            tituloView
            resumoView
            imagemView
            metadataView
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }
}

// MARK: - Componentes
private extension NewsItemView {
    var chapeuView: some View {
        Group {
            if let ch = item.chapeu, !ch.isEmpty {
                Text(ch)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
            }
        }
    }

    var tituloView: some View {
        Text(item.title ?? "")
            .font(.title3.weight(.bold))
            .foregroundColor(.primaryG1)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)
    }

    var resumoView: some View {
        Group {
            if let summary = item.summary, !summary.isEmpty {
                Text(summary)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    var imagemView: some View {
        NewsThumbnail(urlString: item.imageUrl)
            .animation(nil, value: item.imageUrl)
            .padding(.vertical, 16)
    }

    var metadataView: some View {
        Group {
            if let meta = item.metadataText, !meta.isEmpty {
                Text(meta)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }

    var accessibilityText: String {
        [item.chapeu, item.title, item.summary, item.metadataText]
            .compactMap { $0 }
            .joined(separator: ". ")
    }
}

struct NewsThumbnail: View {
    let urlString: String?
    var height: CGFloat = 180
    
    @StateObject private var loader = ImageLoader()
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipped()
                    .cornerRadius(12)
                    .accessibilityHidden(true)
            } else {
                ThumbnailPlaceholder(height: height)
            }
        }
        .onAppear {
            if let urlString, let url = URL(string: urlString) {
                loader.load(from: url)
            }
        }
    }
}

private struct ThumbnailPlaceholder: View {
    var height: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.primary.opacity(0.08))
            .frame(height: height)
            .overlay(Image(systemName: "photo").imageScale(.large).opacity(0.3))
            .accessibilityLabel("Imagem indisponível")
    }
}
