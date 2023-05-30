//
//  VideosStatistics.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 22.05.2023.
//

import Foundation

struct VideoList: Codable {
    let kind: String
    let etag: String
    let items: [VideoListItem]
}

struct VideoListItem: Codable {
    let kind: String
    let etag: String
    let id: String
    let statistics: Statistics
}
