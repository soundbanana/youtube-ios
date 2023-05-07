//
//  SearchPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit
import SWXMLHash

class SearchPresenter {
    weak var view: SearchViewController?
    var navigationController: UINavigationController?

    let session = URLSession.shared
    let parser = XMLParser()

    let service = NetworkSearchService()

    func predict(searchText: String) async {
        guard let url = URL(string: "https://suggestqueries.google.com/complete/search?ds=yt&output=xml&q=\(searchText)") else { return }

        do {
            let (data, _) = try await session.data(from: url)

        } catch {
            print(error)
            return
        }
    }

    func search(searchText: String) async {
        await service.getVideos(searchText: searchText)
    }
}
