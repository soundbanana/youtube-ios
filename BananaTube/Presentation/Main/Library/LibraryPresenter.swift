//
//  LibraryPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 13.05.2023.
//

import Foundation

class LibraryPresenter {
    weak var view: LibraryViewController!
    let coordinator: LibraryCoordinator

    init(coordinator: LibraryCoordinator) {
        self.coordinator = coordinator
    }

    func viewDidLoad() { }

    func showSearch() {
        coordinator.showSearch(searchBarText: "")
    }

    func showProfile() {
        coordinator.showProfile()
    }
}
