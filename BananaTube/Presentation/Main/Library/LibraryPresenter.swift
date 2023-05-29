//
//  LibraryPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 13.05.2023.
//

import Foundation
import Combine

class LibraryPresenter {
    weak var view: LibraryView?
    let coordinator: LibraryCoordinator

    private var videosList: [Item] = []
    var screenState: ScreenState = .unauthorized

    private let service = NetworkVideosService.shared

    private var cancellables = Set<AnyCancellable>()

    init(coordinator: LibraryCoordinator) {
        self.coordinator = coordinator
        UserStore.shared.userStatePublisher
            .sink { state in
            self.handleUserStateChange(state: state)
            }
            .store(in: &cancellables)
    }

    func handleUserStateChange(state: State) {
        switch state {
        case .authorized:
            screenState = .authorized
            Task {
                DispatchQueue.main.async {
                    self.view?.showAuthorizedState()
                }

                await obtainData()

                DispatchQueue.main.async {
                    self.view?.reloadData()
                }
            }
        case .unauthorized:
            screenState = .unauthorized
            videosList = []
            DispatchQueue.main.async {
                self.view?.showUnauthorizedState()
                self.view?.reloadData()
            }
        }
    }

    func obtainData() async {
        switch screenState {
        case .authorized:
            let videos = await fetchVideos()
            let videoIDs = videos.map { $0.id }
            videosList = await service.getRealVideos(videoIds: videoIDs).reversed()
        case .unauthorized:
            videosList = []
        }
    }

    func getCollectionViewSize() -> Int {
        videosList.count
    }

    func fetchVideos() async -> [Video] {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.main.async {
                let videos = CoreDataManager.shared.fetchVideos(userEmail: Constants.USER_EMAIL)
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

            let subtitle = "\(snippet.channelTitle!) \(statistics.viewCount) \("views_label".localized) \(relativeDate)"

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
