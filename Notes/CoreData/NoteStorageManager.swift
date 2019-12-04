//
//  NoteStorageManager.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/4/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import CoreData

final class NoteStorageManager {
    static let shared = NoteStorageManager()
    private var index = 0
    private var noteIndexToId = [Int:UUID]()
    private(set) var managedObjectContext = CoreDataManager.shared.managedContext
    private var managedContextHasBeenSet = false
    
    private init() {
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        managedContextHasBeenSet = true
        let notes = CoreDataManager.shared.loadNotesFromCoreData(managedContext: self.managedObjectContext)
        index = CoreDataManager.shared.count
        for (index, note) in notes.enumerated() {
            noteIndexToId[index] = note.id
        }
    }
    
    func saveNote(note: Note) {
        if managedContextHasBeenSet {
            noteIndexToId[index] = note.id
            CoreDataManager.shared.saveNoteToCoreData(note: note, managedContext: managedObjectContext)
            index += 1
        }
    }
}
