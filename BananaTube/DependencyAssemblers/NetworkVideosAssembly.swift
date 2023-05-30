//
//  NetworkVideosAssembly.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 30.05.2023.
//

import Swinject

final class NetworkVideosAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkVideosService.self) { _ in
            NetworkVideosService()
        }
    }
}
