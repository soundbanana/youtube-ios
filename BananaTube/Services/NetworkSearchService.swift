//
//  NetworkSearchService.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}

enum APIError: Error {
    case invalidResponse
    case apiError(String)
}

class NetworkSearchService {
    let session = URLSession.shared
    let decoder = JSONDecoder()

    func getVideos(searchText: String, completion: @escaping (Result<SearchResult, Error>) -> Void) async {
        let mainPart = "https://youtube.googleapis.com/youtube/v3/search"
        let part = "snippet"
        let maxResults = "20"
        let order = "viewCount"
        let type = "video"
        let q = searchText

        guard let url = URL(string: "\(mainPart)?part=\(part)&maxResults=\(maxResults)&key=\(Constants.API_KEY)&order=\(order)&q=\(q)&type=\(type)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        do {
            let (data, _) = try await session.data(from: url)
            let response = try decoder.decode(SearchResult.self, from: data)

            var videoIds: [String] = []
            for video in response.items {
                videoIds.append(video.id.videoId)
            }

            print(videoIds)

            await getStatistics(videoIds: videoIds) { result in
                switch result {
                case .success(let statistics):
                    print("OK")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }

    func getStatistics(videoIds: [String], completion: @escaping (Result<Subscriptions, Error>) -> Void) async {
        let mainPart = "https://youtube.googleapis.com/youtube/v3/videos"
        let part = "statistics"
        let id = videoIds.joined(separator: "%2C")

        guard let url = URL(string: "\(mainPart)?part=\(part)&id=\(id)&key=\(Constants.API_KEY)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // !TODO Change name of model Subscriptions to smth else
        do {
            let (data, _) = try await session.data(from: url)
            let response = try decoder.decode(Subscriptions.self, from: data)
            print(response)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
}
