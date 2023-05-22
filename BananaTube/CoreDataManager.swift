//
//  CoreDataManager.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 14.05.2023.
//

import UIKit
import CoreData

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

    // MARK: - Video CRUD

    public func createVideo(_ id: String, userEmail: String) {
        guard let videoEntityDescription = NSEntityDescription.entity(forEntityName: "Video", in: context) else {
            return
        }
        let video = Video(entity: videoEntityDescription, insertInto: context)
        video.id = id
        video.userEmail = userEmail

        appDelegate.saveContext()
    }

    public func fetchVideos(for userEmail: String) -> [Video] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        do {
            if let videos = try context.fetch(fetchRequest) as? [Video] {
                return videos.filter { $0.userEmail == userEmail }
            }
        } catch {
            print("Error fetching videos: \(error.localizedDescription)")
        }
        return []
    }

    public func fetchVideo(with id: String) -> Video? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let videos = try context.fetch(fetchRequest) as? [Video] {
                return videos.first
            }
        } catch {
            print("Error fetching video with id \(id): \(error.localizedDescription)")
        }
        return nil
    }

    public func deleteAllVideos() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        do {
            if let videos = try context.fetch(fetchRequest) as? [Video] {
                videos.forEach { context.delete($0) }
                appDelegate.saveContext()
            }
        } catch {
            print("Error deleting all videos: \(error.localizedDescription)")
        }
    }

    public func deleteVideo(with id: String, userEmail: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND userEmail == %@", id, userEmail)
        do {
            if let videos = try context.fetch(fetchRequest) as? [Video],
                let video = videos.first {
                context.delete(video)
                appDelegate.saveContext()
            }
        } catch {
            print("Error deleting video: \(error.localizedDescription)")
        }
    }
}
