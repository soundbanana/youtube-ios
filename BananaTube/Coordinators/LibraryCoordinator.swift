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

        parentTabBarController?.addViewController(
            viewController: viewController,
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
//        let presenter = SearchPresenter(coordinator: LibraryCoordinator.shared, searchBarText: searchBarText)
//        let viewController = SearchViewController()
//
//        viewController.presenter = presenter
//        presenter.view = viewController
//
//        navigationController?.pushViewController(viewController, animated: false)
    }

    func showProfile() {
//        let presenter = ProfilePresenter()
//        let viewController = ProfileViewController()
//
//        viewController.presenter = presenter
//        presenter.view = viewController
//
//        viewController.modalPresentationStyle = .fullScreen
//        navigationController?.present(viewController, animated: true)
    }

    func showVideosList(searchText: String) {
//        navigationController?.popViewController(animated: false)
//
//        let presenter = VideosPresenter(coordinator: LibraryCoordinator.shared, searchText: searchText)
//        let viewController = VideosViewController()
//
//        viewController.presenter = presenter
//        presenter.view = viewController
//
//        navigationController?.pushViewController(viewController, animated: true)
    }

    func showDetails(video: Item) {
//        let presenter = VideoPlaybackPresenter(video: video)
//        let viewController = VideoPlaybackViewController()
//
//        viewController.presenter = presenter
//        presenter.view = viewController
//
//        navigationController?.pushViewController(viewController, animated: true)
    }
}
