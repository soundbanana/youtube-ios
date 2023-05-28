//
//  CoreDataManager.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 14.05.2023.
//

import UIKit
import CoreData

final class CoreDataManager {
    public static let shared = CoreDataManager()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()

    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() { }

    // MARK: - Video CRUD

    public func createVideo(with id: String, userEmail: String) {
        viewContext.performAndWait {
            let video = Video(context: viewContext)
            video.id = id
            video.userEmail = userEmail

            saveContext()
        }
    }

    public func fetchVideos(for userEmail: String) -> [Video] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        do {
            if let videos = try viewContext.fetch(fetchRequest) as? [Video] {
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
            if let videos = try viewContext.fetch(fetchRequest) as? [Video] {
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
            if let videos = try viewContext.fetch(fetchRequest) as? [Video] {
                videos.forEach { viewContext.delete($0) }
                saveContext()
            }
        } catch {
            print("Error deleting all videos: \(error.localizedDescription)")
        }
    }

    public func deleteVideo(with id: String, userEmail: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND userEmail == %@", id, userEmail)
        do {
            if let videos = try viewContext.fetch(fetchRequest) as? [Video],
                let video = videos.first {
                viewContext.delete(video)
                saveContext()
            }
        } catch {
            print("Error deleting video: \(error.localizedDescription)")
        }
    }

    // MARK: - Core Data Helpers

    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
}
