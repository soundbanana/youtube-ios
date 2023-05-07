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
    let items: [SearchItem]
}

struct SearchItem: Decodable {
    let kind: String
    let etag: String
    let id: Id
    let snippet: Snippet
}

struct Id: Decodable {
    let kind: String?
    let videoId: String
}
