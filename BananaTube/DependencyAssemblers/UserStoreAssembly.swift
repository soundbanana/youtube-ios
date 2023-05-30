//
//  UserStoreAssembly.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 30.05.2023.
//

import Swinject

final class UserStoreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserStore.self) { _ in
            UserStore()
        }
    }
}
