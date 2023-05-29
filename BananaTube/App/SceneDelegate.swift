//
//  SceneDelegate.swift
//  YouTube
//
//  Created by Daniil Chemaev on 29.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private var serviceLocator: ServiceLocator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let serviceLocator = ServiceLocator()
        self.window = window
        self.serviceLocator = serviceLocator
        self.appCoordinator = AppCoordinator(window: window, resolver: serviceLocator.getResolver())
        appCoordinator?.start(animated: true)
    }
}
