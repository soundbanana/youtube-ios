//
//  SubscriptionsCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit
import Swinject

class SubscriptionsCoordinator: CoordinatorProtocol, NavbarCoordinator {
    private var resolver: Resolver
    private weak var parentTabBarController: UITabBarController?
    private weak var navigationController: UINavigationController?
    private var childCoordinators: [CoordinatorProtocol] = []
    private var finishHandlers: [(() -> Void)] = []

    init(tabBarController: UITabBarController, resolver: Resolver, finishHandler: @escaping (() -> Void)) {
        self.parentTabBarController = tabBarController
        self.resolver = resolver
        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let subscriptionsViewController = SubscriptionsViewController()
        let subscriptionsPresenter = SubscriptionsPresenter(coordinator: self, view: subscriptionsViewController, service: resolver.resolve())
        subscriptionsViewController.presenter = subscriptionsPresenter
        let navigationController = UINavigationController(rootViewController: subscriptionsViewController)
        self.navigationController = navigationController

        parentTabBarController?.addViewController(
            viewController: navigationController,
            title: "subscriptions_tab_bar_item".localized,
            image: UIImage(systemName: "books.vertical")
        )
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        guard let finishHandler = completion else { return }
        finishHandlers.append(finishHandler)
        childCoordinators.finishAll(animated: animated, completion: nil)
    }

    func showSearch(searchBarText: String) {
        let searchViewController = SearchViewController()
        let searchPresenter = SearchPresenter(
            coordinator: self,
            view: searchViewController,
            searchBarText: searchBarText
        )

        searchViewController.presenter = searchPresenter

        searchPresenter.completion = { [weak self] searchText in
            self?.navigationController?.dismiss(animated: false)

            guard let searchText = searchText else {
                return
            }
            // Push the VideosViewController after the SearchViewController is closed
            let videosViewController = VideosViewController()

            let videosPresenter = VideosPresenter(
                coordinator: self!,
                view: videosViewController,
                service: (self?.resolver.resolve())!,
                searchText: searchText
            )

            videosViewController.presenter = videosPresenter
            self?.navigationController?.pushViewController(videosViewController, animated: true)
        }
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.present(searchNavigationController, animated: false)
    }

    func showProfile() {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(view: profileViewController, authenticationManager: resolver.resolve())

        profileViewController.presenter = profilePresenter

        profileViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(profileViewController, animated: true)
    }

    func showDetails(video: Item) {
        let coordinator = VideoPlaybackCoordinator(
            navigationController: navigationController,
            resolver: resolver,
            video: video
        ) { [weak self] in
            self?.childCoordinators.removeCoordinator(ofType: LibraryCoordinator.self)
        }
        coordinator.start(animated: true)
        childCoordinators.append(coordinator)
    }
}
