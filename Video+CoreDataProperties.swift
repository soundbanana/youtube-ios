//
//  Video+CoreDataProperties.swift
//
//
//  Created by Daniil Chemaev on 14.05.2023.
//
//

import Foundation
import CoreData

@objc(Video) public class Video: NSManagedObject { }

extension Video {
    @NSManaged public var id: String
    @NSManaged public var url: String?
}

extension Video: Identifiable { }
