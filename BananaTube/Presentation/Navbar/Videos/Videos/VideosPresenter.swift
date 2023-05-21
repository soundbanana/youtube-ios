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

    var searchResult: SearchResult!
    let searchText: String
    var videosList: [Item] = []
    var nextPageToken: String = ""

    let service = NetworkSearchService.shared

    init(coordinator: NavbarCoordinator, searchText: String) {
        self.coordinator = coordinator
        self.searchText = searchText
    }

    func viewDidLoad() {
        view?.update(searchBarText: searchText)
    }

    func obtainData() async {
        await service.getVideos(searchText: searchText, nextPageToken: nextPageToken) { result in
            switch result {
            case .success(let searchResult):
                self.searchResult = searchResult
                self.nextPageToken = searchResult.nextPageToken
            case .failure(let error):
                print("Error: \(error)")
            }
        }

        if let searchResult = searchResult {
            let result = searchResult.items.map { searchItem in
                return Item(
                    kind: searchItem.kind,
                    etag: searchItem.etag,
                    id: searchItem.id.videoId,
                    snippet: searchItem.snippet,
                    contentDetails: nil,
                    statistics: searchItem.statistics)
            }
            videosList.append(contentsOf: result)
        }

        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }

    func getCollectionViewSize() -> Int {
        return videosList.count
    }

    func startPagination(row: Int) -> Bool {
        return row == videosList.count - 1 ? true : false
    }

    func configureCell(cell: VideoCollectionViewCell, row: Int) {
        guard let snippet = videosList[row].snippet else {
            print("No snippet provided")
            return
        }
        guard let statistics = videosList[row].statistics
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
        cell.show(title: title, subtitle: subtitle, imageURL: url, liveBroadcast: liveBroadcast)
    }

    func showSearch() {
//        coordinator.showSearch(searchBarText: searchText)
    }

    func showDetails(row: Int) {
        let item = videosList[row]
        coordinator.showDetails(video: item)
    }
}
