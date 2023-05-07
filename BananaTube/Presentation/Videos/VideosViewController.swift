//
//  VideosCollectionView.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit

class VideosViewController: UIViewController {
    var collectionView: UICollectionView! = nil

    var presenter: VideosPresenter!

    var videosList: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
}
