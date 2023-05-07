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
    var coordinator: NavbarCoordinator

    init(coordinator: NavbarCoordinator) {
        self.coordinator = coordinator
    }

    let session = URLSession.shared
    let parser = XMLParser()

    let service = NetworkSearchService()

    func predict(searchText: String) async {
        guard let url = URL(string: "https://suggestqueries.google.com/complete/search?ds=yt&output=xml&q=\(searchText)") else { return }

        do {
            let (data, _) = try await session.data(from: url)

            print(String(data: data, encoding: .ascii)!)
//            let xml = XMLHash.parse(data)
//            let result = xml["toplevel"]["CompleteSuggestion"]["suggestion"].element?.allAttributes
//            print(1)
//            print(result)

//            result = response
        } catch {
            print(error)
            return
        }
    }

    func search(searchText: String) {
        Task {
            let videos = await service.getVideos(searchText: searchText)
        }
        view?.dismiss(animated: false)
        coordinator.showVideos()
    }
}
