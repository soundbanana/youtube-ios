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
    let pageInfo: PageInfo
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
}

struct Snippet: Codable {
    let publishedAt: String
    let title: String
    let description: String
    let resourceId: ResourceId
    let channelId: String
//  let thumbnails: Thumbnails
}

struct ContentDetails: Codable {
    let relatedPlaylists: RelatedPlaylists
}

struct RelatedPlaylists: Codable {
    let likes: String
    let uploads: String
}

struct ResourceId: Codable {
    let kind: String
    let channelId: String
}

//    struct Thumbnails: Codable {
//        let _default = {
//            let url: String
//        }
//        let medium = {
//            let url: String
//        }
//        let high = {
//            let url: String
//        }
//    }
