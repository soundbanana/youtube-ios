//
//  Subscriptions.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 14.04.2023.
//

import Foundation

struct Subscriptions: Codable {
    let kind: String
    let etag: String
    let pageInfo: PageInfo?
    let items: [Item]
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct Item: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: Snippet?
    let contentDetails: ContentDetails?
    let statistics: Statistics?
}

struct Snippet: Codable {
    let publishedAt: String
    let title: String
    let description: String
    let resourceId: ResourceId?
    let channelId: String
    let channelTitle: String?
    let thumbnails: Thumbnails
    let liveBroadcastContent: String?
}

struct ContentDetails: Codable {
    let relatedPlaylists: RelatedPlaylists?
    let videoId: String?
}

struct Statistics: Codable {
    let viewCount: String
    let likeCount: String
    let favouriteCount: String?
    let commentCount: String
}

struct RelatedPlaylists: Codable {
    let likes: String
    let uploads: String
}

struct ResourceId: Codable {
    let kind: String
    let channelId: String
}

struct Thumbnails: Codable {
    private enum CodingKeys: String, CodingKey {
        case default_thumbnail = "default"
        case medium
        case high
        case standard
        case maxres
    }
    let default_thumbnail: Thumbnail
    let medium: Thumbnail
    let high: Thumbnail
    let standard: Thumbnail?
    let maxres: Thumbnail?
}

struct Thumbnail: Codable {
    let url: String
    let width: Int?
    let height: Int?
}
