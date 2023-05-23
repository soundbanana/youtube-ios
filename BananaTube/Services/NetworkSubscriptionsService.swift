//
//  NetworkService.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 14.04.2023.
//

import Foundation
import GoogleSignIn

enum ObtainSubscriptionsResult {
    case success(posts: [String])
    case failure(error: Error)
}

enum NetworkError: Error {
    case unauthorized
    case invalidURL
}

class NetworkSubscriptionsService {
    public static let shared = NetworkSubscriptionsService()

    let session = URLSession.shared
    let decoder = JSONDecoder()

    let videosService = NetworkVideosService.shared

    func getSubscriptionsChannels() async throws -> [String] {
        guard let accessToken = GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString else {
            throw NetworkError.unauthorized
        }

        guard let url = URL(string: "\(Constants.BASE_URL)/subscriptions?part=snippet&access_token=\(accessToken)&mine=true&maxResults=50&key=\(Constants.API_KEY)") else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await session.data(from: url)
        let response = try decoder.decode(Subscriptions.self, from: data)

        let subscriptions = response.items
            .filter { $0.kind == "youtube#subscription" }
            .compactMap { $0.snippet?.resourceId?.channelId }

        return subscriptions
    }

    func getPlaylists(subscriptions: [String]) async throws -> [String] {
        guard let url = URL(string: "\(Constants.BASE_URL)/channels?part=contentDetails&id=\(subscriptions.joined(separator: "%2C"))&maxResults=50&key=\(Constants.API_KEY)") else {
            throw NetworkError.invalidURL
        }

        let (contentDetails, _) = try await session.data(from: url)
        let response = try decoder.decode(ChannelListResponse.self, from: contentDetails)

        let playlists = response.items
            .compactMap { $0.contentDetails.relatedPlaylists.uploads }

        return playlists
    }

    func getPlaylistItems(playlist: String) async throws -> [String] {
        guard !playlist.isEmpty else {
            return []
        }

        guard let url = URL(string: "\(Constants.BASE_URL)/playlistItems?part=contentDetails&playlistId=\(playlist)&maxResults=10&key=\(Constants.API_KEY)") else {
            throw NetworkError.invalidURL
        }

        let (playlistItems, _) = try await session.data(from: url)
        let response = try decoder.decode(PlaylistItems.self, from: playlistItems)

        let videoIds = response.items
            .filter { $0.kind == "youtube#playlistItem" }
            .compactMap { $0.contentDetails.videoId }

        return videoIds
    }

    func getSubscriptions(completion: @escaping (Result<[Item], Error>) -> Void) async {
        do {
            let subscriptions = try await getSubscriptionsChannels()
            let playlists = try await getPlaylists(subscriptions: subscriptions)

            var allItems: [String] = []

            for playlist in playlists {
                allItems.append(contentsOf: try await getPlaylistItems(playlist: playlist))
            }

            // The playlist items don't contain the correct published date, so now we have to fetch every video in batches of 50.
            var allVideos: [Item] = []

            if allItems.count > 50 {
                let chunks = allItems.chunked(into: 50)

                for chunk in chunks {
                    allVideos.append(contentsOf: await videosService.getRealVideos(videoIds: chunk))
                }
            } else {
                allVideos.append(contentsOf: await videosService.getRealVideos(videoIds: allItems))
            }

            let sortedVideos = allVideos.sorted { $0.snippet?.publishedAt ?? "" > $1.snippet?.publishedAt ?? "" }
            completion(.success(sortedVideos))
        } catch {
            completion(.failure(error))
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
