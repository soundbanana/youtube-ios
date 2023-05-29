//
//  MainTabBarCoordinator.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit
import Swinject

class MainTabBarCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController?
    private var window: UIWindow
    private var resolver: Resolver
    private var tabBarController: UITabBarController = {
        var tabBar = UITabBarController()
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.tintColor = UIColor(named: "MainText")
        tabBar.tabBar.barTintColor = UIColor(named: "Background")
        tabBar.tabBar.backgroundImage = UIImage()
        tabBar.tabBar.shadowImage = UIImage()
        return tabBar
    }()

    private var childCoordinators: [CoordinatorProtocol] = []
    private var finishHandlers: [(() -> Void)] = []

    init(window: UIWindow, resolver: Resolver, finishHandler: @escaping (() -> Void)) {
        self.window = window
        self.resolver = resolver
        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        window.rootViewController = tabBarController
        let subscriptionsCoordinator = SubscriptionsCoordinator(
            window: tabBarController,
            resolver: resolver
        ) { [weak self] in
            self?.childCoordinators.removeCoordinator(ofType: SubscriptionsCoordinator.self)
        }

//        let libraryCoordinator = LibraryCoordinator(
//            window:
//        )

        subscriptionsCoordinator.start(animated: false)
        childCoordinators.append(subscriptionsCoordinator)

    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        guard let finishHandler = completion else { return }
        finishHandlers.append(finishHandler)
        childCoordinators.finishAll(animated: animated, completion: nil)
    }



    private func subscriptions() -> UIViewController {
        let viewController = SubscriptionsViewController()
        viewController.tabBarItem = .init(
            title: "subscriptions_tab_bar_item".localized,
            image: UIImage(systemName: "books.vertical"),
            selectedImage: .init(systemName: "books.vertical.fill")
        )
        return SubscriptionsCoordinator.shared.start(viewController)
    }

    private func library() -> UIViewController {
        let viewController = LibraryViewController()
        viewController.tabBarItem = .init(
            title: "library_tab_bar_item".localized,
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
