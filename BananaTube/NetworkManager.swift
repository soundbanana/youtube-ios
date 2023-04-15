//
//  NetworkService.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 14.04.2023.
//

import Foundation

enum ObtainSubscriptionsResult {
    case success(posts: [String])
    case failure(error: Error)
}

@MainActor
class NetworkManager {

    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()

//    func get_channel_for_user(channelId: String){
//        var url =  "\(Constants.BASE_URL)/channels?part=id&forUsername=\(Constants.CHANNEL_ID)&key=\(Constants.API_KEY)"
//        response = urllib.request.urlopen(url)
//        data = json.load(response)
//        return data['items'][0]['id']
//    }

    @MainActor
    func getPlaylists(channelId: String) async -> [String] {

        var playlists: [String] = []

        var result: Subscriptions

        guard let url = URL(string: "\(Constants.BASE_URL)/subscriptions?part=snippet&channelId=\(channelId)&maxResults=50&key=\(Constants.API_KEY)") else { return [] }

        var subs = [String]()

        do {
            let (data, _) = try await session.data(from: url)
            let response = try decoder.decode(Subscriptions.self, from: data)
            result = response
        } catch {
            fatalError()
        }

        for item in result.items where item.kind == "youtube#subscription" {
            subs.append(item.snippet!.resourceId.channelId)
        }

        guard let purl = URL(string: "\(Constants.BASE_URL)/channels?part=contentDetails&id=\(subs.joined(separator: "%2C"))&maxResults=50&key=\(Constants.API_KEY)") else { return [] }

        do {
            let (contentDetails, _) = try await session.data(from: purl)
            let response = try decoder.decode(Subscriptions.self, from: contentDetails)
            result = response
        } catch {
            fatalError()
        }

        for item in result.items {
            playlists.append((item.contentDetails?.relatedPlaylists?.uploads)!)
        }

        return playlists
    }

    func getPlaylistItems(playlist: String) async -> [String] {
        var videos: [String] = []

        // Get the last 5 items from every playlist
        if (!playlist.isEmpty) {
            guard let url = URL(string: "\(Constants.BASE_URL)/playlistItems?part=contentDetails&playlistId=\(playlist)&maxResults=5&key=\(Constants.API_KEY)") else {
                return []
            }

            var statusCode = 200

            do {
                let (playlistItems, _) = try await session.data(from: url)
                let response = try decoder.decode(Subscriptions.self, from: playlistItems)

                for item in response.items where item.kind == "youtube#playlistItem" {
                    videos.append((item.contentDetails?.videoId)!)
                }
            } catch {
            }
        }
        return videos
    }

//    func getSubscriptions(channelId: String, completion: @escaping([String]) -> Void) async {
    func getSubscriptions(channelId: String) async {

        var playlists: [String] = []

//        defer {
//            completion(playlists)
//        }

        // Get all upload playlists of subbed channels
        playlists = await getPlaylists(channelId: channelId)

        // Get the last 5 items from every playlist
        var allItems: [String] = []

        for playlist in playlists {
            await allItems.append(contentsOf: getPlaylistItems(playlist: playlist))
        }
        print(allItems)
    }
}
