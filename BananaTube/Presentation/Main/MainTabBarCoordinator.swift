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
        customizeTabBarAppearance()

        tabBarController.viewControllers = [
            subscriptions(),
            library()
        ]

        return tabBarController
    }

    private func subscriptions() -> UIViewController {
        let viewController = SubscriptionsViewController()
        viewController.tabBarItem = .init(
            title: "Subscriptions",
            image: UIImage(systemName: "books.vertical"),
            selectedImage: .init(systemName: "books.vertical.fill")
        )
        return SubscriptionsCoordinator.shared.start(viewController)
    }

    private func library() -> UIViewController {
        let viewController = LibraryViewController()
        viewController.tabBarItem = .init(
            title: "Library",
            image: UIImage(systemName: "folder"),
            selectedImage: .init(systemName: "folder.fill")
        )
        return LibraryCoordinator.shared.start(viewController)
    }

    private func customizeTabBarAppearance() {
        if let tabBar = tabBarController?.tabBar {
            tabBar.isTranslucent = false
            tabBar.tintColor = UIColor(named: "MainText")
            tabBar.barTintColor = UIColor(named: "Background")
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
        }
    }
}
