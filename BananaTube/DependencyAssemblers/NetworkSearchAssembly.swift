//
//  NetworkSearchService.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 30.05.2023.
//

import Swinject

final class NetworkSearchAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkSearchService.self) { _ in
            NetworkSearchService()
        }
    }
}
