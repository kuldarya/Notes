//
//  NotesMO+CoreDataProperties.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/4/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//
//

import Foundation
import CoreData


extension NotesMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesMO> {
        return NSFetchRequest<NotesMO>(entityName: "NotesMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var textBody: String?
    @NSManaged public var date: Date?

}
