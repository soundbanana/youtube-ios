//
//  AppCoordinator.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

@MainActor
class AppCoordinator {
    weak var window: UIWindow?
    static let shared: AppCoordinator = .init()

    func showAppContent() {
        let tabBarCoordinator = MainTabBarCoordinator()
        window?.rootViewController = tabBarCoordinator.start()
    }
}

