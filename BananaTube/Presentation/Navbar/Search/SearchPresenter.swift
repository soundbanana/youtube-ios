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
    var searchResult: SearchResult?

    func predict(searchText: String) async {
        let encodedTexts = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: "https://suggestqueries.google.com/complete/search?ds=yt&output=xml&q=\(encodedTexts!)") else {
            return }

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
    }

    func rowTapped(row: Int) {
        search(searchText: predictionsList[row])
    }

    func search(searchText: String) {
        Task {
            await service.getVideos(searchText: searchText) { result in
                switch result {
                case .success(let searchResult):
                    self.searchResult = searchResult
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            DispatchQueue.main.async { [self] in
                if let searchResult = searchResult {
                    view?.dismiss(animated: false)
                    coordinator.showVideos(searchResult: searchResult)
                }
            }
        }
    }

    func configureCell(cell: PredictionsTableViewCell, row: Int) {
        cell.configure(title: predictionsList[row])
    }

    func getPredictionsListSize() -> Int { predictionsList.count }
}
