//
//  AppCoordinator.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit
import Swinject

class AppCoordinator: CoordinatorProtocol {
    private var window: UIWindow
    private var resolver: Resolver
    private var childCoordinators: [CoordinatorProtocol] = []

    init(window: UIWindow, resolver: Resolver) {
        self.window = window
        self.resolver = resolver
    }

    func start(animated: Bool) {
        window.makeKeyAndVisible()
        showMain()
    }

    func showMain() {
        let tabBarCoordinator = MainTabBarCoordinator(window: window, resolver: resolver) { [weak self] in
            self?.childCoordinators.removeCoordinator(ofType: MainTabBarCoordinator.self)
        }
        tabBarCoordinator.start(animated: false)
        childCoordinators.append(tabBarCoordinator)
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
    }
}
