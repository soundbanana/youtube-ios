//
//  VideosCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 09.05.2023.
//

import UIKit

class VideosCoordinator {
    static let shared: VideosCoordinator = .init()
    private var navigationController: UINavigationController?

    func showDetails(video: Item) {
        let presenter = VideoPlaybackPresenter(video: video)
        let viewController = VideoPlaybackViewController()

        viewController.presenter = presenter
        presenter.view = viewController

        navigationController?.pushViewController(viewController, animated: true)
    }
}
