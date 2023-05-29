//
//  SceneDelegate.swift
//  YouTube
//
//  Created by Daniil Chemaev on 29.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        let coordinator = AppCoordinator()

        coordinator.window = window
        coordinator.start(animated: false)
        window.makeKeyAndVisible()
        self.window = window
    }
}
