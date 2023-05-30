//
//  NetworkSubscriptionsAssembly.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import Swinject

final class NetworkSubscriptionsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkSubscriptionsService.self) { resolver in
            let networkVideosService = resolver.resolve(NetworkVideosService.self)!
            return NetworkSubscriptionsService(networkVideosService: networkVideosService)
        }
    }
}
