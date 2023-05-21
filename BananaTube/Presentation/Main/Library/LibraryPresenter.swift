//
//  LibraryPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 13.05.2023.
//

import Foundation
import Combine

class LibraryPresenter {
    weak var view: LibraryViewController?
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
        // Handle sign-in and sign-out state changes in the LibraryPresenter
        switch state {
        case .authorized:
            print("Lib authorized")
        case .unauthorized:
            print("Lib unauthorized")
        }
    }

    func viewDidLoad() async {
        if Constants.USER_EMAIL.isEmpty {
            screenState = .unauthorized
        } else {
            screenState = .authorized
        }
        await obtainData()
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

        DispatchQueue.main.async { [weak self] in
            self?.view?.setupViewState()
        }
    }

    func getCollectionViewSize() -> Int {
        videosList.count
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

//// MARK: - ProfilePresenterDelegate
//
//extension LibraryPresenter: AuthenticationStateDelegate {
//    func didSignIn() {
//        screenState = .authorized
//        print("LIB RECIEVED AUTHORIZED")
////
////        Task {
////            await obtainData()
////        }
////
////        DispatchQueue.main.async {
////            self.view?.setupViewState()
////        }
//    }
//
//    func didSignOut() {
//        screenState = .unauthorized
//        print("LIB RECIEVED UNAUTHORIZED")
////        videosList = []
////        DispatchQueue.main.async {
////            self.view?.setupViewState()
////        }
//    }
//}
