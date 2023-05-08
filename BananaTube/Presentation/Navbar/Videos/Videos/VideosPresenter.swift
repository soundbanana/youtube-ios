//
//  VideosPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit

class VideosPresenter {
    weak var view: VideosViewController?
    var navigationController: UINavigationController?

    var coordinator: NavbarCoordinator

    var videosList: [SearchItem]

    init(coordinator: NavbarCoordinator, videosList: [SearchItem]) {
        self.coordinator = coordinator
        self.videosList = videosList
    }

    func showSearch() {
        coordinator.showSearch()
    }

    func foo() {
        print(videosList)
    }
}
