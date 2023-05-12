//
//  SubscriptionsCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

class SubscriptionsCoordinator: NavbarCoordinator {
    static let shared: SubscriptionsCoordinator = .init()
    private var navigationController: UINavigationController?
    var tabBarCoordinator = MainTabBarCoordinator.shared

    func start(_ viewController: SubscriptionsViewController) -> UIViewController {
        let presenter = SubscriptionsPresenter(coordinator: SubscriptionsCoordinator.shared)
        viewController.presenter = presenter
        presenter.view = viewController

        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController!
    }

    func showDetails(video: Item) {
        let presenter = VideoPlaybackPresenter(video: video)
        let viewController = VideoPlaybackViewController()

        viewController.presenter = presenter
        presenter.view = viewController

        navigationController?.pushViewController(viewController, animated: true)
    }

    func showSearch(searchBarText: String) {
        let presenter = SearchPresenter(coordinator: SubscriptionsCoordinator.shared, searchBarText: searchBarText)
        let viewController = SearchViewController()

        viewController.presenter = presenter
        presenter.view = viewController

        navigationController?.pushViewController(viewController, animated: false)
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
        navigationController?.popViewController(animated: false)

        let presenter = VideosPresenter(coordinator: SubscriptionsCoordinator.shared, searchText: searchText)
        let viewController = VideosViewController()

        viewController.presenter = presenter
        presenter.view = viewController

        navigationController?.pushViewController(viewController, animated: true)
    }
}
