//
//  MenuView.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @State private var didAppear = false
    @State private var selected: URLItem?

    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                Button {
                    if let url = URL(string: item.url) {
                        selected = URLItem(url: url)
                    }
                } label: {
                    MenuItemView(title: item.title)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
            .navigationTitle("Menu")
            .refreshable { await viewModel.reload() }
            .overlay(statusOverlay)
        }
        .sheet(item: $selected) {
            SafariView(url: $0.url).ignoresSafeArea()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if !didAppear {
                didAppear = true
                Task { await viewModel.load() }
            }
        }
    }

    @ViewBuilder
    private var statusOverlay: some View {
        switch viewModel.state {
        case .loading where viewModel.items.isEmpty:
            ProgressView().scaleEffect(1.2)
        case .error(let msg) where viewModel.items.isEmpty:
            VStack(spacing: 12) {
                Text(msg).foregroundColor(.secondary).multilineTextAlignment(.center)
                Button("Tentar novamente") { Task { await viewModel.reload() } }
            }.padding()
        case .loaded where viewModel.items.isEmpty:
            Text("Nada por aqui.").foregroundColor(.secondary)
        default:
            EmptyView()
        }
    }
}
