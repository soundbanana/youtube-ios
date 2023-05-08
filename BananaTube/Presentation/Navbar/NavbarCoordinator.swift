//
//  NavbarProtocol.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import Foundation

protocol NavbarCoordinator {
    func showSearch()
    func showVideos(searchResult: SearchResult)
}
