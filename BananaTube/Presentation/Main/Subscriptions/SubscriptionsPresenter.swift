//
//  SubscriptionsPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

class SubscriptionsPresenter {
    weak var view: SubscriptionsViewController?
    var navigationController: UINavigationController?

    private var videosList: [Item] = []

    let coordinator: SubscriptionsCoordinator

    private let networkSubscriptionsService = NetworkSubscriptionsService.shared

    init(coordinator: SubscriptionsCoordinator) {
        self.coordinator = coordinator
    }

    func viewDidLoad() async {
        await obtainData()
    }

    func obtainData() async {
        await networkSubscriptionsService.getSubscriptions { result in
            self.videosList = result
        }
        DispatchQueue.main.async { [self] in
            view?.reloadData()
        }
    }

    func refreshData() async {
        videosList = []
        await obtainData()
    }

    func getCollectionViewSize() -> Int {
        videosList.isEmpty ? 5 : videosList.count
    }

    func configureCell(cell: VideoCollectionViewCell, row: Int) {
        if videosList.capacity > row {
            guard let snippet = videosList[row].snippet else { return }
            guard let statistics = videosList[row].statistics else { return }

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
    }

    func showDetails(row: Int) {
        if videosList.capacity > row {
            let item = videosList[row]
            coordinator.showDetails(video: item)
        }
    }

    func showSearch() {
        coordinator.showSearch(searchBarText: "")
    }

    func showProfile() {
        coordinator.showProfile()
    }
}
