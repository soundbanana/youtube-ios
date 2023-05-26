//
//  SubscriptionsPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit
import Combine
import GoogleSignIn

enum ScreenState {
    case authorized
    case unauthorized
}

class SubscriptionsPresenter {
    weak var view: SubscriptionsViewController?
    let coordinator: SubscriptionsCoordinator

    private var videosList: [Item] = []
    var screenState: ScreenState = .unauthorized

    private let networkSubscriptionsService = NetworkSubscriptionsService.shared

    private var cancellables = Set<AnyCancellable>()

    init(coordinator: SubscriptionsCoordinator) {
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

            DispatchQueue.main.async {
                self.view?.showLoadingIndicator(true)
                self.view?.showAuthorizedState()
            }

            Task {
                await obtainData()

                DispatchQueue.main.async {
                    self.view?.showLoadingIndicator(false)
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
            let accessToken = GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString
            await networkSubscriptionsService.getSubscriptions(accessToken: accessToken) { result in
                switch result {
                case .success(let videos):
                    self.videosList = videos
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        case .unauthorized:
            videosList = []
        }
    }

    func getCollectionViewSize() -> Int {
        videosList.count
    }

    func configureCell(cell: VideoCollectionViewCell, row: Int) {
        guard row < videosList.count else {
            return
        }
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
