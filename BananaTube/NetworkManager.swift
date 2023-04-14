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

    func getPlaylists(channelId: String, completion: @escaping([String]) -> Void) async {

        var playlists: [String] = []

        var result: Subscriptions

        defer {
            completion(playlists)
        }

        guard let url = URL(string: "\(Constants.BASE_URL)/subscriptions?part=snippet&channelId=\(channelId)&maxResults=50&key=\(Constants.API_KEY)") else { return }

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

        guard let purl = URL(string: "\(Constants.BASE_URL)/channels?part=contentDetails&id=\(subs.joined(separator: "%2C"))&maxResults=50&key=\(Constants.API_KEY)") else { return }

        do {
            let (contentDetails, _) = try await session.data(from: purl)
            let response = try decoder.decode(Subscriptions.self, from: contentDetails)
            result = response
        } catch {
            fatalError()
        }

        for item in result.items {
            playlists.append((item.contentDetails?.relatedPlaylists.uploads)!)
        }

        completion(playlists)
    }
}
