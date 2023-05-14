//
//  VideoPlaybackPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 24.04.2023.
//

import UIKit

class VideoPlaybackPresenter {
    weak var view: VideoPlaybackViewController?
    var video: Item
    var navigationController: UINavigationController?

    init(video: Item) {
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

        let subtitle = "\(snippet.channelTitle!) \(statistics.viewCount) views \(relativeDate)"

        let videoId = video.id

        view?.show(title: title, subtitle: subtitle, videoId: videoId)

        CoreDataManager.shared.createVideo(videoId)
    }
}
