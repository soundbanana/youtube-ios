//
//  CoreDataManager.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 14.05.2023.
//

import UIKit
import CoreData

// MARK: - CRUD
public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() { }

    private var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate instance.")
        }
        return delegate
    }

    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    public func createVideo(_ id: String) {
        guard let videoEntityDescription = NSEntityDescription.entity(forEntityName: "Video", in: context) else {
            return
        }
        let photo = Video(entity: videoEntityDescription, insertInto: context)
        photo.id = id

        appDelegate.saveContext()
    }

    public func fetchVideos() -> [Video] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        do {
            return (try? context.fetch(fetchRequest) as? [Video]) ?? []
        }
    }

    public func fetchVideo(with id: String) -> Video? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let videos = try? context.fetch(fetchRequest) as? [Video]
            return videos?.first
        }
    }

    public func deletaAllVideos() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        do {
            let videos = try? context.fetch(fetchRequest) as? [Video]
            videos?.forEach { context.delete($0) }
        }

        appDelegate.saveContext()
    }

    public func deleteVideo(with id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let videos = try? context.fetch(fetchRequest) as? [Video],
                let video = videos.first else { return }
            context.delete(video)
        }

        appDelegate.saveContext()
    }
}
