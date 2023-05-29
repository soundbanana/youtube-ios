//
//  NetworkSubscriptionsAssembly.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import Swinject

final class NetworkSubscriptionsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkSubscriptionsService.self) { _ in
            NetworkSubscriptionsService()
        }
    }
}
