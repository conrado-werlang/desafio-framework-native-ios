//
//  MainTabView.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NewsFeedView(source: .g1)
                .tabItem {
                    Label("Notícias", systemImage: "newspaper")
                }

            NewsFeedView(source: .agro)
                .tabItem {
                    Label("Agronegócio", systemImage: "leaf")
                }
        
            Text("Menu")
                .tabItem {
                    Label("Menu", systemImage: "list.bullet")
                }
        }
    }
}
