//
//  VideoPlaybackCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import UIKit
import Swinject

class VideoPlaybackCoordinator: CoordinatorProtocol {
    private var resolver: Resolver
    private weak var navigationController: UINavigationController?
    private var childCoordinators: [CoordinatorProtocol] = []
    private var finishHandlers: [(() -> Void)] = []

    private var video: Item

    init(navigationController: UINavigationController?, resolver: Resolver, video: Item, finishHandler: @escaping (() -> Void)) {
        self.navigationController = navigationController
        self.resolver = resolver
        self.video = video
        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let viewController = VideoPlaybackViewController()
        let presenter = VideoPlaybackPresenter(
            view: viewController,
            coordinator: self,
            video: video
        )
        viewController.presenter = presenter

        navigationController?.pushViewController(viewController, animated: animated)
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        guard let finishHandler = completion else { return }
        finishHandlers.append(finishHandler)
        childCoordinators.finishAll(animated: animated, completion: nil)
    }
}
