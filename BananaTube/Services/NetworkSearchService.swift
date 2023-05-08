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
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
}
