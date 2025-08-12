//
//  SafariView.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController { SFSafariViewController(url: url) }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) { }
}
