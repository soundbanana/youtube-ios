//
//  Resolver+Extensions.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import Swinject

// swiftlint:disable force_unwrapping
extension Resolver {
    func resolve<T>() -> T {
        return resolve(T.self)!
    }

    func resolve<T>(name: String?) -> T {
        return resolve(T.self, name: name)!
    }

    func resolve<T, Arg1>(argument: Arg1) -> T {
        return resolve(T.self, argument: argument)!
    }
}
// swiftlint:enable force_unwrapping
