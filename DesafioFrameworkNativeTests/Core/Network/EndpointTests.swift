//
//  EndpointTests.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 13/08/25.
//

import XCTest
@testable import DesafioFrameworkNative

final class EndpointTests: XCTestCase {
    
    func testURL_WhenFetchingFirstTimeG1_ShouldMatchURLpath() {
        // Given
        let url = Endpoint.first(.g1).url.absoluteString
        // Then
        XCTAssertEqual(url, "https://native-leon.globo.com/feed/g1")
    }
    
    func testURL_WhenFetchingFirstTimeAgro_ShouldMatchURLpath() {
        // Given
        let url = Endpoint.first(.agro).url.absoluteString
        // Then
        XCTAssertEqual(url, "https://native-leon.globo.com/feed/https://g1.globo.com/economia/agronegocios")
    }
    
    func testURL_WhenPaginatingG1_ShouldMatchURLpath() {
        // Given
        let url = Endpoint.page(.g1, oferta: "abc", page: 3).url.absoluteString
        // Then
        XCTAssertEqual(url, "https://native-leon.globo.com/feed/page/g1/abc/3")
    }
    
    func testURL_WhenPaginatingAgro_ShouldMatchURLpath() {
        // Given
        let url = Endpoint.page(.agro, oferta: "abc", page: 6).url.absoluteString
        // Then
        XCTAssertEqual(url, "https://native-leon.globo.com/feed/page/g1/abc/6")
    }
}
