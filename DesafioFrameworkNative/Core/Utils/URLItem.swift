//
//  URL+Identifiable.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import Foundation

struct URLItem: Identifiable, Equatable {
    let url: URL
    var id: String { url.absoluteString }
}
