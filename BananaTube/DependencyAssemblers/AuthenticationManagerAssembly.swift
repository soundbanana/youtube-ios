//
//  NetworkAuthenticationAssembly.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import Swinject

final class AuthenticationManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthenticationManager.self) { _ in
            AuthenticationManager()
        }
    }
}
