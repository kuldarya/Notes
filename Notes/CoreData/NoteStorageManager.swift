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
    private var currentIndex = 0
    private var noteIndexToId = [Int:UUID]()
    private(set) var managedContext = CoreDataManager.shared.managedContext
    private var managedContextHasBeenSet = false
    
    private init() {
        managedContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        managedContext = managedObjectContext
        managedContextHasBeenSet = true
        let notes = CoreDataManager.shared.fetchAllNotes(managedContext: managedContext)
        currentIndex = CoreDataManager.shared.count
        for (index, note) in notes.enumerated() {
            noteIndexToId[index] = note.id
        }
    }
    
    // MARK: - Saving
    
    func saveNote(note: Note) {
        if managedContextHasBeenSet {
            noteIndexToId[currentIndex] = note.id
            CoreDataManager.shared.saveNoteToCoreData(note: note, managedContext: managedContext)
            currentIndex += 1
        }
    }
    
    // MARK: - Loading to VC
    
    func loadNote(at index: Int) -> Note? {
        if managedContextHasBeenSet {
            if index < 0 || index > currentIndex - 1 {
                assertionFailure("Note cannot be found")
                return nil
            }
            
            let noteUUID = noteIndexToId[index]
            let note: Note?
            
            if let noteId = noteUUID {
                note = CoreDataManager.shared.fetchNote(noteId: noteId, managedContext: managedContext)
                return note
            }
        }
        return nil
    }
}
