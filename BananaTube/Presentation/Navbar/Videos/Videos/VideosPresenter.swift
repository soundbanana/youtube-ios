//
//  VideosPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit

class VideosPresenter {
    weak var view: VideosViewController?
    var navigationController: UINavigationController?

    var coordinator: NavbarCoordinator
    var videosCoordinator = VideosCoordinator.shared

    var searchResult: SearchResult!
    let searchText: String!
    var items: [Item] = []

    let service = NetworkSearchService()

    init(coordinator: NavbarCoordinator, searchText: String) {
        self.coordinator = coordinator
        self.searchText = searchText
    }

    func showSearch() {
        coordinator.showSearch()
    }

    func obtainData() async {
        await service.getVideos(searchText: searchText) { result in
            switch result {
            case .success(let searchResult):
                self.searchResult = searchResult
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        if let searchResult = searchResult {
            items = searchResult.items.map { searchItem in
                return Item(
                    kind: searchItem.kind,
                    etag: searchItem.etag,
                    id: searchItem.id.videoId,
                    snippet: searchItem.snippet,
                    contentDetails: nil,
                    statistics: searchItem.statistics)
            }
        }

        print("OBTAIN DATA \(String(describing: searchResult))\n")

        DispatchQueue.main.async {
            self.view?.videosList = self.items
            self.view?.collectionView.reloadData()
        }
    }

    func configureCell(cell: VideoCollectionViewCell, row: Int) {
        guard let snippet = items[row].snippet else {
            print("No snippet provided")
            return
        }
        guard let statistics = items[row].statistics
            else {
            print("No statistics provided")
            return
        }

        let title = snippet.title

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = Date().addingTimeInterval(dateFormatter.date(from: snippet.publishedAt)!.timeIntervalSinceNow)
        let formatter = RelativeDateTimeFormatter()
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        let subtitle = "\(snippet.channelTitle!) \(statistics.viewCount) views \(relativeDate)"

        guard let url = URL(string: snippet.thumbnails.high.url) else { return }

        let liveBroadcast: Bool
        if snippet.liveBroadcastContent == "live" {
            liveBroadcast = true
        } else {
            liveBroadcast = false
        }

        print(title)

        cell.show(title: title, subtitle: subtitle, imageURL: url, liveBroadcast: liveBroadcast)
    }

    func showDetails(row: Int) {
        let item = items[row]
        coordinator.showDetails(video: item)
    }
}
