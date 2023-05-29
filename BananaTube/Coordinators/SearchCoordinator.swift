//
//  SearchCoordinator.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import UIKit
import Swinject

class SearchCoordinator: CoordinatorProtocol {
    private var resolver: Resolver
    private weak var navigationController: UINavigationController?
    private var parentNavCoordinator: NavbarCoordinator?
    private var childCoordinators: [CoordinatorProtocol] = []
    private var finishHandlers: [(() -> Void)] = []

    private var searchBarText: String

    init(navigationController: UINavigationController?, parentNavCoordinator: NavbarCoordinator, resolver: Resolver, searchBarText: String, finishHandler: @escaping (() -> Void)) {
        self.navigationController = navigationController
        self.parentNavCoordinator = parentNavCoordinator
        self.resolver = resolver
        self.searchBarText = searchBarText
        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let viewController = SearchViewController()
        let presenter = SearchPresenter(view: viewController, coordinator: parentNavCoordinator!, searchBarText: searchBarText)
        viewController.presenter = presenter

        navigationController?.pushViewController(viewController, animated: animated)
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        guard let finishHandler = completion else { return }
        finishHandlers.append(finishHandler)
        childCoordinators.finishAll(animated: animated, completion: nil)
    }
}
