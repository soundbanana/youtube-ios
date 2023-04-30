//
//  SubscriptionsCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

class SubscriptionsCoordinator {
    static let shared: SubscriptionsCoordinator = .init()
    var navigationController: UINavigationController?
    var mainTabBarCoordinator = MainTabBarCoordinator.shared

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
}
