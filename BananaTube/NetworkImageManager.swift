//
//  NetworkImageManager.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 16.04.2023.
//

import Foundation

class NetworkImageManager {

    public static let instance = NetworkImageManager()

    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()

    private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = session.downloadTask(with: imageURL) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, error)
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, error)
                return
            }

            do {
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func image(imageURL: URL, completion: @escaping (Data?, Error?) -> Void) {
        download(imageURL: imageURL, completion: completion)
    }
}
