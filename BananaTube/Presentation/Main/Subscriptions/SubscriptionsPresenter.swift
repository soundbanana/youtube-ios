//
//  SubscriptionsPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

class SubscriptionsPresenter {
    weak var view: SubscriptionsViewController?
    var subscriptions: [Item]?
    var navigationController: UINavigationController?

    let coordinator: SubscriptionsCoordinator

    init(coordinator: SubscriptionsCoordinator) {
        self.coordinator = coordinator
    }

    private let networkSubscriptionsService = NetworkSubscriptionsService.shared

    func obtainData() async {
        await networkSubscriptionsService.getSubscriptions { result in
            self.subscriptions = result
            DispatchQueue.main.async { [self] in
                view?.subscriptionsList = self.subscriptions ?? []
                view?.collectionView.reloadData()
            }
        }
    }

    func configureCell(cell: VideoCollectionViewCell, row: Int) {
        guard let snippet = subscriptions?[row].snippet else { return }
        guard let statistics = subscriptions?[row].statistics else { return }

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

    func showDetails(row: Int) {
        guard let item = subscriptions?[row] else { return }
        coordinator.showDetails(video: item)
    }

    func showSearch() {
        coordinator.showSearch(searchBarText: "")
    }

    func showProfile() {
        coordinator.showProfile()
    }
}
