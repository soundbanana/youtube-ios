//
//  SearchViewController.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

struct ViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerGenerator: () -> UIViewController

    init(viewControllerGenerator: @escaping () -> UIViewController) {
        self.viewControllerGenerator = viewControllerGenerator
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        viewControllerGenerator()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct PreviewViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SearchViewController()
        }
    }
}
