//
//  Extension + UIViewController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import UIKit

extension UIViewController {
    func createCustomNavigationBar() {
        navigationController?.navigationBar.barTintColor = .systemBackground
    }

    func createCustomTitleView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 280, height: 41)

        let iconImage: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "icon")
            image.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            return image
        }()

        view.addSubview(iconImage)

        return view
    }

    func createCustomTitleButton(imageName: String, selector: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(
            UIImage(named: imageName),
            for: .normal
        )
        button.imageView?.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .left
        if (selector) != nil {
            button.addTarget(self, action: selector!, for: .touchUpInside)
        }
        let menuBarItem = UIBarButtonItem(customView: button)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 150)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 41)
        currHeight?.isActive = true

        return menuBarItem
    }

    func createCustomButton(imageName: String, selector: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)

        if (selector) != nil {
            button.addTarget(self, action: selector!, for: .touchUpInside)
        }

        let menuBarItem = UIBarButtonItem(customView: button)

        return menuBarItem
    }
}
