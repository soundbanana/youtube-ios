//
//  PlaylistItem.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 22.05.2023.
//

import Foundation

struct PlaylistItems: Decodable {
    let kind: String
    let etag: String
    let nextPageToken: String?
    var items: [PlaylistItem]
    let pageInfo: PageInfo
}

struct PlaylistItem: Codable {
    let kind: String?
    let etag: String
    let id: String
    let contentDetails: PlaylistItemsContentDetails
}

struct PlaylistItemsContentDetails: Codable {
    let videoId: String
    let videoPublishedAt: String
}
