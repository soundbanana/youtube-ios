//
//  SubscriptionsPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

class SubscriptionsPresenter {

    weak var view: SubscriptionsViewController?
    var subsriptions: [Item]?
    var navigationController: UINavigationController?

    private let networkSubscriptionsService: NetworkSubscriptionsService = NetworkSubscriptionsService.shared

    func obtainData() {
        Task {
            await networkSubscriptionsService.getSubscriptions(channelId: Constants.CHANNEL_ID) { result in
                self.subsriptions = result
                DispatchQueue.main.async { [self] in
                    view?.subscriptionsList = self.subsriptions ?? []
                    view?.collectionView.reloadData()
                }
            }
        }
    }
}
