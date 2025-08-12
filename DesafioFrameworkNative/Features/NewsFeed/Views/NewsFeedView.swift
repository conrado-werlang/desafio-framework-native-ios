//
//  NewsFeedView.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel: NewsFeedViewModel
    @State private var didAppear = false
    @State private var selectedURL: URLItem?
    
    private let source: FeedSource
    
    init(source: FeedSource) {
        _viewModel = StateObject(wrappedValue: NewsFeedViewModel(source: source))
        self.source = source
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NewsItemView(item: item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let link = item.url, let url = URL(string: link) {
                                selectedURL = URLItem(url: url)
                            }
                        }
                        .task { await viewModel.loadNextPageIfNeeded(currentItem: item) }
                }

                if viewModel.isLoadingNextPage {
                    HStack { Spacer(); ProgressView(); Spacer() }
                }
            }
            .listStyle(.plain)
            .navigationTitle(source.title)
            .refreshable { await viewModel.reload() }
            .overlay(statusOverlay)
        }
        .sheet(item: $selectedURL) { item in
            SafariView(url: item.url)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if !didAppear {
                didAppear = true
                Task { await viewModel.loadFirstPage() }
            }
        }
    }

    @ViewBuilder
    private var statusOverlay: some View {
        switch viewModel.state {
        case .loading where viewModel.items.isEmpty:
            ProgressView().scaleEffect(1.2)
        case .error(let message) where viewModel.items.isEmpty:
            VStack(spacing: 12) {
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Button("Tente novamente") { Task { await viewModel.reload() } }
            }
            .padding()
        case .loaded where viewModel.items.isEmpty:
            Text("Sem notícias no momento.")
                .foregroundColor(.secondary)
        default:
            EmptyView()
        }
    }
}
