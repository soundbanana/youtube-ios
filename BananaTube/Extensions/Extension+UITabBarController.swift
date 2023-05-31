//
//  Extension+UITabBarController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 31.05.2023.
//

import UIKit

extension UITabBarController {
    func addViewController(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) {
        viewController.title = title
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        var viewControllers = self.viewControllers ?? []
        viewControllers.append(viewController)
        setViewControllers(viewControllers, animated: true)
    }
}
