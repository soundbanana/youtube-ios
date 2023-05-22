//
//  SubscriptionsPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit
import Combine

enum ScreenState {
    case authorized
    case unauthorized
}

class SubscriptionsPresenter {
    weak var view: SubscriptionsViewController?
    var navigationController: UINavigationController?

    private var videosList: [Item] = []
    var screenState: ScreenState = .unauthorized

    let coordinator: SubscriptionsCoordinator

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
            Task {
                DispatchQueue.main.async {
                    self.view?.setupViewState()
                    self.view?.showLoadingIndicator(true)
                }

                await obtainData()

                DispatchQueue.main.async {
                    self.view?.showLoadingIndicator(false)
                }
            }
        case .unauthorized:
            screenState = .unauthorized
            Task {
                await obtainData()
            }
        }
    }

    func obtainData() async {
        switch screenState {
        case .authorized:
            await networkSubscriptionsService.getSubscriptions { result in
                self.videosList = result
            }
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
