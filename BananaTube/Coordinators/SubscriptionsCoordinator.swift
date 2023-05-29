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
        let viewController = SubscriptionsViewController()
        let presenter = SubscriptionsPresenter(coordinator: self)
        viewController.presenter = presenter
        presenter.view = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
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
        print(123)
        let searchViewController = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchViewController, coordinator: self, searchBarText: searchBarText)
        searchViewController.presenter = searchPresenter

        searchPresenter.completion = { [weak self] in
            print(456)

            // Push the VideosViewController after the SearchViewController is closed
            let videosViewController = VideosViewController()
            let videosPresenter = VideosPresenter(coordinator: self!, searchText: searchBarText)
            videosViewController.presenter = videosPresenter
            self?.navigationController?.pushViewController(videosViewController, animated: true)
        }
        navigationController?.pushViewController(searchViewController, animated: false)

//            // Check if the SearchViewController is already in the navigation stack
//            if let searchViewControllerIndex = navigationController?.viewControllers.firstIndex(where: { $0 is SearchViewController }) {
//                // Pop the SearchViewController and execute the completion block
//                navigationController?.popToViewController( navigationController?.viewControllers[searchViewControllerIndex], animated: true, completion: completionBlock)
//            } else {
//                // Push the SearchViewController onto the navigation stack and execute the completion block
//                navigationController?.pushViewController(searchViewController, animated: true, completion: completionBlock)
//            }

            // Set the searchBarText in the shared SearchPresenter
//            searchPresenter.searchBarText = searchBarText
    }

    func showProfile() {
        let presenter = ProfilePresenter()
        let viewController = ProfileViewController()

        viewController.presenter = presenter
        presenter.view = viewController

        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }

    func showVideosList(searchText: String) {
//        navigationController?.popViewController(animated: false)
//
//        let presenter = VideosPresenter(coordinator: SubscriptionsCoordinator.shared, searchText: searchText)
//        let viewController = VideosViewController()
//
//        viewController.presenter = presenter
//        presenter.view = viewController
//
//        navigationController?.pushViewController(viewController, animated: true)
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
