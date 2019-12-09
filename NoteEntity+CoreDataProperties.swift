//
//  NoteEntity+CoreDataProperties.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/4/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var noteTimeStamp: Date?
    @NSManaged public var noteId: UUID?
    @NSManaged public var noteBody: String?
    @NSManaged public var noteTitle: String?

}
