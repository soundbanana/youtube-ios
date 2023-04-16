//
//  SubscriptionsCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

class SubscriptionsCoordinator {
    static let shared = SubscriptionsCoordinator()
    var navigationController: UINavigationController?

    func start(_ viewController: SubscriptionsViewController) -> UIViewController {
        let presenter = SubscriptionsPresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController!
    }

}
