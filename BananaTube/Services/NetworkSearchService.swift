//
//  NetworkSearchService.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case apiError(String)
}

class NetworkSearchService {
    static let shared = NetworkSearchService()
    let session = URLSession.shared
    let decoder = JSONDecoder()

    private init() { }

    func getVideos(searchText: String, nextPageToken: String, completion: @escaping (Result<SearchResult, Error>) -> Void) async {
        let mainPart = "https://youtube.googleapis.com/youtube/v3/search"
        let part = "snippet"
        let maxResults = "5"
        let order = "viewCount"
        let type = "video"
        let pageToken = nextPageToken
        let q = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: "\(mainPart)?part=\(part)&maxResults=\(maxResults)&key=\(Constants.API_KEY)&order=\(order)&q=\(q!)&type=\(type)&pageToken=\(pageToken)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        do {
            let (data, _) = try await session.data(from: url)
            var response = try decoder.decode(SearchResult.self, from: data)

            // Due to search does't have statistics part, I need to do additional API request
            var videoIds: [String] = []
            for video in response.items {
                videoIds.append(video.id.videoId)
            }

            var stats: [Statistics] = []
            await getStatistics(videoIds: videoIds) { result in
                switch result {
                case .success(let statistics):
                    for item in statistics.items {
                        stats.append(item.statistics)
                    }
                case .failure(let error):
                    print("Error while getting statistics: \(error.localizedDescription)")
                }
            }

            if stats.count == response.items.count {
                for i in 0..<response.items.count {
                    response.items[i].statistics = stats[i]
                }
            }
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }

    private func getStatistics(videoIds: [String], completion: @escaping (Result<VideoList, Error>) -> Void) async {
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
            let response = try decoder.decode(VideoList.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
}
