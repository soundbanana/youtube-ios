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

    init(coordinator: NavbarCoordinator) {
        self.coordinator = coordinator
    }

    func showSearch() {
        coordinator.showSearch()
    }
}
