//
//  MainTabBarCoordinator.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

class MainTabBarCoordinator {
    static let shared: MainTabBarCoordinator = .init()
    weak var tabBarController: UITabBarController?

    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        tabBarController.tabBar.tintColor = .black

        tabBarController.viewControllers = [
//            home(),
            subscriptions(),
            library()
        ]

        return tabBarController
    }

    private func home() -> UIViewController {
        let viewController = HomeViewController()
        viewController.tabBarItem = .init(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        viewController.tabBarItem.badgeColor = UIColor(named: "MainText")
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    private func subscriptions() -> UIViewController {
        let viewController = SubscriptionsViewController()
        viewController.tabBarItem = .init(
            title: "Subscriptions",
            image: .init(systemName: "books.vertical"),
            selectedImage: .init(systemName: "books.vertical.fill")
        )
        return SubscriptionsCoordinator.shared.start(viewController)
    }

    private func library() -> UIViewController {
        let viewController = LibraryViewController()
        viewController.tabBarItem = .init(
            title: "Library",
            image: .init(systemName: "folder"),
            selectedImage: .init(systemName: "folder.fill")
        )
        return LibraryCoordinator.shared.start(viewController)
    }
}
