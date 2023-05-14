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

    private let service = NetworkVideosService.shared

    private var videosList: [Item] = []

    init(coordinator: LibraryCoordinator) {
        self.coordinator = coordinator
    }

    func viewDidLoad() { }

    func obtainData() async {
        let videos = await fetchVideos()
        let videoIDs = videos.map { $0.id }
        let result = await service.getRealVideos(videoIds: videoIDs)
    }

    func fetchVideos() async -> [Video] {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.main.async {
                let videos = CoreDataManager.shared.fetchVideos()
                continuation.resume(returning: videos)
            }
        }
    }

    func showSearch() {
        coordinator.showSearch(searchBarText: "")
    }

    func showProfile() {
        coordinator.showProfile()
    }
}
