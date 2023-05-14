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

    let service = NetworkVideosService.shared

    init(coordinator: LibraryCoordinator) {
        self.coordinator = coordinator
    }

    func viewDidLoad() { }

    func obtainData() async {
        let result = await service.getRealVideos(videoIds: ["123"])
        print(result)
    }

    func showSearch() {
        coordinator.showSearch(searchBarText: "")
    }

    func showProfile() {
        coordinator.showProfile()
    }
}
