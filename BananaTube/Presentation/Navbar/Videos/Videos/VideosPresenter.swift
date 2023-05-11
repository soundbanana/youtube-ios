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

    var searchResult: SearchResult
    var items: [Item] = []

    init(coordinator: NavbarCoordinator, searchResult: SearchResult) {
        self.coordinator = coordinator
        self.searchResult = searchResult
    }

    func showSearch() {
        coordinator.showSearch()
    }

    func obtainData() {
        print("OBTAIN DATA \(searchResult)\n")
        items = searchResult.items.map { searchItem in
            return Item(
                kind: searchItem.kind,
                etag: searchItem.etag,
                id: searchItem.id.videoId,
                snippet: searchItem.snippet,
                contentDetails: nil,
                statistics: searchItem.statistics)
        }

        view?.videosList = items
        DispatchQueue.main.async {
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

//    func showDetails(row: Int) {
//        let item = searchResult.items[row]
//        videosCoordinator.showDetails(video: item)
//    }
}
