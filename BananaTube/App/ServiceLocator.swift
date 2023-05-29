//
//  ServiceLocator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import Swinject

protocol ServiceLocatorProtocol {
    func getResolver() -> Resolver
}

final class ServiceLocator: ServiceLocatorProtocol {
    private var container: Container
    private var assembler: Assembler

    init() {
        self.container = Container()
        self.assembler = Assembler(
            [
                NetworkSubscriptionsAssembly(),
                AuthenticationManagerAssembly()
            ],
            container: container
        )
    }

    func getResolver() -> Resolver {
        return assembler.resolver
    }
}
