//
//  CoreDataManager.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/4/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack

    lazy var managedContext = persistentContainer.viewContext

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteEntity")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() throws {
        guard managedContext.hasChanges else {
            return
        }
        try managedContext.save()
    }
    
    func saveNote(note: Note) {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(NoteEntity.id), note.id as CVarArg])
        
        if let savedNote = try? managedContext.fetch(request).first {
            savedNote.title = note.title
            savedNote.textBody = note.textBody
        } else {
            _ = NoteEntity(note: note, context: managedContext)
        }
        
        do {
            try saveContext()
        } catch let error as NSError {
            assertionFailure("Could not save note to CoreData: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Core Data Fetching support
    
    func fetchNotes() -> [Note] {
        var notes = [Note]()
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        let sortDescriptor = [NSSortDescriptor(key: #keyPath(NoteEntity.timeStamp), ascending: false)]
        request.sortDescriptors = sortDescriptor
        
        do {
            let fetchedNotes = try managedContext.fetch(request)
            notes = fetchedNotes.map { .init(noteEntity: $0) }
        } catch let error as NSError {
            assertionFailure("Could not fetch notes from CoreData: \(error), \(error.userInfo)")
        }
        return notes
    }

    // MARK: - Core Data Deleting support
    
    func deleteNote(note: Note) {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(NoteEntity.id), note.id as CVarArg])
        
        do {
            let notes = try managedContext.fetch(request)
            for note in notes {
                managedContext.delete(note)
            }
        } catch let error as NSError {
            assertionFailure("Could not fetch notes from CoreData: \(error), \(error.userInfo)")
        }
        
        do {
            try saveContext()
        } catch let error as NSError {
            assertionFailure("Could not save notes to CoreData: \(error), \(error.userInfo)")
        }
    }
}
