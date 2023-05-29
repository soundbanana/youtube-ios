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

        parentTabBarController?.addViewController(
            viewController: viewController,
            title: "subscriptions_tab_bar_item".localized,
            image: UIImage(systemName: "books.vertical"),
            selectedImage: UIImage(systemName: "book.vertical.fill")
        )
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        guard let finishHandler = completion else { return }
        finishHandlers.append(finishHandler)
        childCoordinators.finishAll(animated: animated, completion: nil)
    }


    func showSearch(searchBarText: String) {
//        let presenter = SearchPresenter(coordinator: SubscriptionsCoordinator.shared, searchBarText: searchBarText)
//        let viewController = SearchViewController()
//
//        viewController.presenter = presenter
//        presenter.view = viewController
//
//        navigationController?.pushViewController(viewController, animated: true)
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
//        let presenter = VideosPresenter(coordinator: SubscriptionsCoordinator.shared, searchText: searchText)
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
