//
//  NavbarProtocol.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import Foundation

protocol NavbarCoordinator {
    func showSearch(searchBarText: String)
    func showProfile()
    func showDetails(video: Item)
}
