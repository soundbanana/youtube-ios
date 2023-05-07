//
//  NetworkSearchService.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import Foundation

class NetworkSearchService {
    let session = URLSession.shared
    let decoder = JSONDecoder()

    func getVideos(searchText: String) async -> [Item] {
        let mainPart = "https://youtube.googleapis.com/youtube/v3/search"
        let part = "snippet"
        let maxResult = "50"
        let order = "viewCount"
        let type = "video"
        let q = searchText

        guard let url = URL(string: "\(mainPart)?part=\(part)&maxResult\(maxResult)&key=\(Constants.API_KEY)&order=\(order)&q=\(q)&type=\(type)") else { return [] }

        do {
            let (data, _) = try await session.data(from: url)
            let response = try decoder.decode(SearchResult.self, from: data)
            print(response)
            return []
        } catch {
            print(error)
            return []
        }
    }
}
