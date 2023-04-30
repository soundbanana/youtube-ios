//
//  ViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 29.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = createCustomTitleButton(imageName: "light-icon", selector: nil)

        let accountButton = createCustomButton(imageName: "person.circle.fill", action: .profile)
        let searchButton = createCustomButton(imageName: "magnifyingglass", action: .search)

        navigationItem.rightBarButtonItems = [accountButton, searchButton]
    }
}
