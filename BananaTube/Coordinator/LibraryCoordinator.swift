//
//  LibraryCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 13.05.2023.
//

import UIKit
import Swinject

class LibraryCoordinator: CoordinatorProtocol, NavbarCoordinator {
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
        let viewController = LibraryViewController()
        let presenter = LibraryPresenter(coordinator: self)
        viewController.presenter = presenter
        presenter.view = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController

        parentTabBarController?.addViewController(
            viewController: navigationController,
            title: "library_tab_bar_item".localized,
            image: UIImage(systemName: "folder")
        )
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        guard let finishHandler = completion else { return }
        finishHandlers.append(finishHandler)
        childCoordinators.finishAll(animated: animated, completion: nil)
    }

    func showSearch(searchBarText: String) {
        let searchViewController = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchViewController, coordinator: self, searchBarText: searchBarText)
        searchViewController.presenter = searchPresenter

        searchPresenter.completion = { [weak self] searchText in
            self?.navigationController?.dismiss(animated: false)

            guard let searchText = searchText else {
                return
            }
            // Push the VideosViewController after the SearchViewController is closed
            let videosViewController = VideosViewController()
            let videosPresenter = VideosPresenter(view: videosViewController, coordinator: self!, searchText: searchText)
            videosViewController.presenter = videosPresenter
            self?.navigationController?.pushViewController(videosViewController, animated: true)
        }
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.present(searchNavigationController, animated: false)    }

    func showProfile() {
        let presenter = ProfilePresenter()
        let viewController = ProfileViewController()

        viewController.presenter = presenter
        presenter.view = viewController

        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
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
