//
//  SearchResult.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import Foundation

struct SearchResult: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let regionCode: String
    let pageInfo: PageInfo
    var items: [SearchItem]
}

struct SearchItem: Codable {
    let kind: String
    let etag: String
    let id: Identity
    let snippet: Snippet?
    var statistics: Statistics?
}

struct Identity: Codable {
    let kind: String?
    let videoId: String
}
