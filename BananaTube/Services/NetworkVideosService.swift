//
//  NetworkVideosService.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 14.05.2023.
//

import Foundation

class NetworkVideosService {
    static let shared = NetworkVideosService()
    let session = URLSession.shared
    let decoder = JSONDecoder()

    private init() { }

    func getRealVideos(videoIds: [String]) async -> [Item] {
        var videos: [Item] = []

        guard let purl = URL(string: "\(Constants.BASE_URL)/videos?part=snippet,statistics&id=\(videoIds.joined(separator: "%2C"))&maxResults=50&key=\(Constants.API_KEY)") else { return [] }
        do {
            let (contentDetails, _) = try await session.data(from: purl)
            let response = try decoder.decode(Subscriptions.self, from: contentDetails)
            videos = response.items
        } catch {
            print(error.localizedDescription)
        }
        return videos
    }
}
