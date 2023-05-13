//
//  LibraryCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 13.05.2023.
//

import UIKit

class LibraryCoordinator: NavbarCoordinator {
    static let shared: LibraryCoordinator = .init()
    private var navigationController: UINavigationController?

    func start(_ viewController: LibraryViewController) -> UIViewController {
        let presenter = LibraryPresenter(coordinator: LibraryCoordinator.shared)
        viewController.presenter = presenter
        presenter.view = viewController

        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController!
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

    func showDetails(video: Item) {
        let presenter = VideoPlaybackPresenter(video: video)
        let viewController = VideoPlaybackViewController()

        viewController.presenter = presenter
        presenter.view = viewController

        navigationController?.pushViewController(viewController, animated: true)
    }
}
