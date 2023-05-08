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

    let testButton: UIButton = {
        var button = UIButton()
        button.setTitle("Test", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(testButton)
        testButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)

        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc func showSearch() {
        presenter.foo()
    }
}
