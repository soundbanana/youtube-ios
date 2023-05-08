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

    var videosList: [SearchItem] = []

    init(coordinator: NavbarCoordinator, videosList: [SearchItem]) {
        self.coordinator = coordinator
        self.videosList = videosList
    }

    func showSearch() {
        coordinator.showSearch()
    }

    func configureCell(cell: VideoCollectionViewCell, row: Int) {
        let snippet = videosList[row].snippet
//        guard let statistics = videosList[row].statistics else { return }

        let title = snippet.title

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = Date().addingTimeInterval(dateFormatter.date(from: snippet.publishedAt)!.timeIntervalSinceNow)
        let formatter = RelativeDateTimeFormatter()
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

//        let subtitle = "\(snippet.channelTitle!) \(statistics.viewCount) views \(relativeDate)"
        let subtitle = ""

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
