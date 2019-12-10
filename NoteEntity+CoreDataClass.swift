//
//  NoteEntity+CoreDataClass.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/4/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//
//

import CoreData

@objc(NoteEntity)
public class NoteEntity: NSManagedObject {
    convenience init?(note: Note, context: NSManagedObjectContext) {
        self.init(managedObjectContext: context)
        
        self.id = note.id
        self.title = note.title
        self.textBody = note.textBody
        self.timeStamp = note.timeStamp
    }
}
