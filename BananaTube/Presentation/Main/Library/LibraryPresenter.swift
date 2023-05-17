//
//  LibraryPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 13.05.2023.
//

import Foundation

class LibraryPresenter {
    weak var view: LibraryViewController!
    let coordinator: LibraryCoordinator

    private let service = NetworkVideosService.shared

    private var videosList: [Item] = []

    init(coordinator: LibraryCoordinator) {
        self.coordinator = coordinator
    }

    func viewDidLoad() async {
        await obtainData()
    }

    func obtainData() async {
        let videos = await fetchVideos()
        let videoIDs = videos.map { $0.id }
        videosList = await service.getRealVideos(videoIds: videoIDs).reversed()
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

    func fetchVideos() async -> [Video] {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.main.async {
                let videos = CoreDataManager.shared.fetchVideos()
                continuation.resume(returning: videos)
            }
        }
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
