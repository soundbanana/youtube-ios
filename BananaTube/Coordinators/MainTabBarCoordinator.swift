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
        tabBar.tabBar.tintColor = UIColor(named: "MainText")
        tabBar.tabBar.barTintColor = UIColor(named: "Background")
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
            tabBarController: tabBarController,
            resolver: resolver
        ) { [weak self] in
            self?.childCoordinators.removeCoordinator(ofType: SubscriptionsCoordinator.self)
        }

        let libraryCoordinator = LibraryCoordinator(
            tabBarController: tabBarController,
            resolver: resolver
        ) { [weak self] in
            self?.childCoordinators.removeCoordinator(ofType: LibraryCoordinator.self)
        }

        subscriptionsCoordinator.start(animated: false)
        libraryCoordinator.start(animated: false)
        childCoordinators.append(subscriptionsCoordinator)
        childCoordinators.append(libraryCoordinator)
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        guard let finishHandler = completion else { return }
        finishHandlers.append(finishHandler)
        childCoordinators.finishAll(animated: animated, completion: nil)
    }

//
//    private func library() -> UIViewController {
//        let viewController = LibraryViewController()
//        viewController.tabBarItem = .init(
//            title: "library_tab_bar_item".localized,
//            image: UIImage(systemName: "folder"),
//            selectedImage: .init(systemName: "folder.fill")
//        )
//        return LibraryCoordinator.shared.start(viewController)
//    }
}

extension UITabBarController {
    func addViewController(viewController: UIViewController, title: String, image: UIImage?) {
        viewController.title = title
        viewController.tabBarItem.image = image
        var viewControllers = self.viewControllers ?? []
        viewControllers.append(viewController)
        setViewControllers(viewControllers, animated: true)
    }
}
