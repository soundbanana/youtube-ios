//
//  SearchResult.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import Foundation

struct SearchResult: Decodable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let regionCode: String
    let pageInfo: PageInfo
    var items: [SearchItem]
}

struct SearchItem: Decodable {
    let kind: String
    let etag: String
    let id: Id
    let snippet: Snippet
    var statistics: Statistics?
}

struct Id: Decodable {
    let kind: String?
    let videoId: String
}
