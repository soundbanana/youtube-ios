//
//  Extension + UIViewController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

enum Action {
    case search
    case profile
}

extension UIViewController {
    func createCustomNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
    }

    func createCustomTitle(text: String, selector: Selector?) -> UIBarButtonItem {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabel.text = text
        titleLabel.textColor = UIColor(named: "MainText")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        titleView.addSubview(titleLabel)

        let titleBarButton = UIBarButtonItem(customView: titleView)

        return titleBarButton
    }

    func createCustomButton(imageName: String, selector: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: .system)

        button.setImage(
            UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = UIColor(named: "MainText")
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)

        if selector != nil {
            button.addTarget(self, action: selector!, for: .touchUpInside)
        }

        let menuBarItem = UIBarButtonItem(customView: button)

        return menuBarItem
    }
}
