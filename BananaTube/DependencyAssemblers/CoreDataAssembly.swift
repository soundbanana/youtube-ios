//
//  CoreDataAssembly.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 30.05.2023.
//

import Swinject

final class CoreDataAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CoreDataManager.self) { _ in
            CoreDataManager()
        }
    }
}
