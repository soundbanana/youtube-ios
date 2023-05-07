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

@MainActor
class NetworkSubscriptionsService {
    public static let shared = NetworkSubscriptionsService()

    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()

    @MainActor
    func getPlaylists() async -> [String] {
        var playlists: [String] = []

        var result: Subscriptions

        guard let accessToken = GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString else { return [] }

        guard let url = URL(string: "\(Constants.BASE_URL)/subscriptions?part=snippet&access_token=\(accessToken)&mine=true&maxResults=50&key=\(Constants.API_KEY)") else { return [] }

        var subs: [String] = []

        do {
            let (data, _) = try await session.data(from: url)
            let response = try decoder.decode(Subscriptions.self, from: data)
            result = response
        } catch {
            print(error)
            return []
        }

        for item in result.items where item.kind == "youtube#subscription" {
            subs.append(item.snippet!.resourceId!.channelId)
        }

        guard let purl = URL(string: "\(Constants.BASE_URL)/channels?part=contentDetails&id=\(subs.joined(separator: "%2C"))&maxResults=50&key=\(Constants.API_KEY)") else { return [] }

        do {
            let (contentDetails, _) = try await session.data(from: purl)
            let response = try decoder.decode(Subscriptions.self, from: contentDetails)
            result = response
        } catch {
            print(error)
        }

        for item in result.items {
            playlists.append((item.contentDetails?.relatedPlaylists?.uploads)!)
        }

        return playlists
    }

    func getPlaylistItems(playlist: String) async -> [String] {
        var videos: [String] = []

        // Get the last 5 items from every playlist
        if !playlist.isEmpty {
            guard let url = URL(string: "\(Constants.BASE_URL)/playlistItems?part=contentDetails&playlistId=\(playlist)&maxResults=5&key=\(Constants.API_KEY)") else {
                return []
            }

            do {
                let (playlistItems, _) = try await session.data(from: url)
                let response = try decoder.decode(Subscriptions.self, from: playlistItems)

                for item in response.items where item.kind == "youtube#playlistItem" {
                    videos.append((item.contentDetails?.videoId)!)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return videos
    }

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

    func getSubscriptions(completion: @escaping([Item]) -> Void) async {
        var result: [Item] = []

        defer {
            completion(result)
        }

        var playlists: [String] = []
        // Get all upload playlists of subbed channels
        playlists = await getPlaylists()

        // Get the last 5 items from every playlist
        var allItems: [String] = []

        for playlist in playlists {
            await allItems.append(contentsOf: getPlaylistItems(playlist: playlist))
        }

        // The playlist items don't contain the correct published date, so now we have to fetch every video in batches of 50.
        var allVids: [Item] = []
        if allItems.count > 50 {
            let chunks = Chuncks(chunk: allItems, n: 50)

            for chunk in chunks {
                await allVids.append(contentsOf: (getRealVideos(videoIds: chunk)))
            }
        } else {
            await allVids.append(contentsOf: (getRealVideos(videoIds: allItems)))
        }

        result = allVids.sorted { $0.snippet!.publishedAt > $1.snippet!.publishedAt }
    }
}

struct Chuncks: Sequence, IteratorProtocol {
    var chunk: [String]
    var n: Int
    var i = 0

    mutating func next() -> [String]? {
        if i + n >= chunk.count {
            return nil
        } else {
            defer { i += 50 }
            return Array(chunk[i..<i + n])
        }
    }
}
