//
//  FeedResponse.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 11/08/25.
//

import Foundation

struct FeedResponse: Decodable {
    let items: [News]?
    let nextPage: Int?
}
