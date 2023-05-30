//
//  ChannelListResponse.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 22.05.2023.
//

import Foundation

struct ChannelListResponse: Codable {
    let kind: String
    let etag: String
    let pageInfo: PageInfo?
    let items: [ChannelListResponseItem]
}

struct ChannelListResponseItem: Codable {
    let kind: String
    let etag: String
    let id: String
    let contentDetails: ChannelListResponseContentDetails
    let statistics: Statistics?
}

struct ChannelListResponseContentDetails: Codable {
    let relatedPlaylists: RelatedPlaylists
}

struct RelatedPlaylists: Codable {
    let likes: String
    let uploads: String
}
