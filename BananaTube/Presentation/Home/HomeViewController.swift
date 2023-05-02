//
//  ViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 29.03.2023.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class HomeViewController: UIViewController {
    private let service = Constants.service

    let button: UIButton = {
        var button = UIButton()
        button.setTitle("Test", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = createCustomTitleButton(imageName: "light-icon", selector: nil)

        let accountButton = createCustomButton(imageName: "person.circle.fill", action: .profile)
        let searchButton = createCustomButton(imageName: "magnifyingglass", action: .search)

        navigationItem.rightBarButtonItems = [accountButton, searchButton]

        view.addSubview(button)
        button.addTarget(self, action: #selector(foo), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100)
            ])

//        self.service.authorizer = user.authentication.fetcherAuthorizer()
    }

    @objc func foo() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: ["snippet", "statistics"])

//        query.identifier = ["UC_x5XG1OV2P6uZZ5FSM9Ttw"]

        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
        query.mine = true
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket: finishedWithObject: error:)))
    }

    // Process the response and display output
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response: GTLRYouTube_ChannelListResponse,
        error: NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }

        var outputText = ""
        if let channels = response.items, !channels.isEmpty {
            let channel = response.items![0]
            let title = channel.snippet!.title
            let description = channel.snippet?.descriptionProperty
            let viewCount = channel.statistics?.viewCount
            outputText += "title: \(title!)\n"
            outputText += "description: \(description!)\n"
            outputText += "view count: \(viewCount!)\n"
        }
        print(outputText)
    }

    // Helper for showing an alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
