//
//  VideoPlaybackPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 24.04.2023.
//

import UIKit

class VideoPlaybackPresenter {
    private weak var view: VideoPlaybackViewController?
    private let coordinator: VideoPlaybackCoordinator
    private var video: Item

    init(view: VideoPlaybackViewController, coordinator: VideoPlaybackCoordinator, video: Item) {
        self.view = view
        self.coordinator = coordinator
        self.video = video
    }

    func configureData() {
        guard let snippet = video.snippet else { return }
        guard let statistics = video.statistics else { return }

        let title = snippet.title

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = Date().addingTimeInterval(dateFormatter.date(from: snippet.publishedAt)!.timeIntervalSinceNow)
        let formatter = RelativeDateTimeFormatter()
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        let subtitle = "\(snippet.channelTitle!) \(statistics.viewCount) \("views_label".localized) \(relativeDate)"

        let videoId = video.id

        view?.show(title: title, subtitle: subtitle, videoId: videoId)

        if !Constants.USER_EMAIL.isEmpty {
            DispatchQueue.main.async {
                CoreDataManager.shared.deleteVideo(id: videoId, userEmail: Constants.USER_EMAIL)
                CoreDataManager.shared.createVideo(id: videoId, userEmail: Constants.USER_EMAIL)
            }
        }
    }
}
