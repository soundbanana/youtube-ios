//
//  Coordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    func start(animated: Bool)
    func finish(animated: Bool, completion: (() -> Void)?)
}

extension Array where Element == CoordinatorProtocol {
    func coordinator<T: CoordinatorProtocol>(ofType type: T.Type) -> T? {
        guard let firstCoordinator = first(where: { $0 is T }) as? T else { return nil }
        return firstCoordinator
    }

    mutating func removeCoordinator<T: CoordinatorProtocol>(ofType type: T.Type) {
        guard let index = firstIndex(where: { $0 is T }) else { return }
        remove(at: index)
    }
}

extension Array where Element == CoordinatorProtocol {
    func finishAll(animated: Bool, completion: (() -> Void)?) {
        guard let coordinator = self.first else {
            completion?()
            return
        }

        coordinator.finish(animated: animated) {
            var arr = self
            arr.removeFirst()
            arr.finishAll(animated: animated, completion: completion)
        }
    }
}
