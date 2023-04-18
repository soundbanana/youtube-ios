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
        createCustomNavigationBar()

        navigationItem.leftBarButtonItem = createCustomButton(imageName: "light-icon", selector: nil)
    }
}
