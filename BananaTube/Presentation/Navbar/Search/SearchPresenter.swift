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
    var predictionsList: [String] = []

    func predict(searchText: String) async {
        let encodedTexts = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: "https://suggestqueries.google.com/complete/search?ds=yt&output=xml&q=\(encodedTexts!)") else {
            return }

        let result: [String]
        do {
            let (data, _) = try await session.data(from: url)
            let xml = XMLHash.parse(data)

            let predictons = xml["toplevel"]["CompleteSuggestion"].all.map { elem in
                elem["suggestion"].element?.attribute(by: "data")?.text
            }
            predictionsList = predictons.compactMap { $0 }
        } catch {
            print(error)
            return
        }
//        print(result)
    }

    func search(searchText: String) {
        Task {
            let videos = await service.getVideos(searchText: searchText)
        }
        view?.dismiss(animated: false)
        coordinator.showVideos()
    }

    func configureCell(cell: PredictionsTableViewCell, row: Int) {
        cell.configure(title: predictionsList[row])
    }

    func getPredictionsListSize() -> Int { predictionsList.count }
}
