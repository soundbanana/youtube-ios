//
//  ViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 29.03.2023.
//

import UIKit

class HomeViewController: UIViewController {

    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        Task {
            await networkManager.getPlaylists(channelId: "UCqKaoE5W0WDnQHG9jU21daQ", completion: { (result) in
                print(result)
            })
        }
    }
}
