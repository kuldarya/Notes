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

    lazy var persistentContainer: NSPersistentContainer = {
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
        request.predicate = NSPredicate(format: "noteId = %@", note.id as CVarArg)
        
        if let savedNote = try? managedContext.fetch(request).first {
            savedNote.noteTitle = note.title
            savedNote.noteBody = note.textBody
        } else {
            guard let entity = NSEntityDescription.entity(forEntityName: NoteEntity.className, in: managedContext) else {
                assertionFailure()
                return
            }
            let noteMO = NSManagedObject(entity: entity, insertInto: managedContext)
            
            noteMO.setValue(note.id, forKey: #keyPath(NoteEntity.noteId))
            noteMO.setValue(note.title, forKey: #keyPath(NoteEntity.noteTitle))
            noteMO.setValue(note.textBody, forKey: #keyPath(NoteEntity.noteBody))
            noteMO.setValue(note.timeStamp, forKey: #keyPath(NoteEntity.noteTimeStamp))
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NoteEntity.className)
        
        let sortDescriptor = [NSSortDescriptor(key: #keyPath(NoteEntity.noteTimeStamp), ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            let fetchedNotes = try managedContext.fetch(fetchRequest)
            fetchedNotes.forEach { result in
                
                guard let id = result.value(forKey: #keyPath(NoteEntity.noteId)) as? UUID,
                    let title = result.value(forKey: #keyPath(NoteEntity.noteTitle)) as? String,
                    let textBody = result.value(forKey: #keyPath(NoteEntity.noteBody)) as? String,
                    let timeStamp = result.value(forKey: #keyPath(NoteEntity.noteTimeStamp)) as? Date else {
                        return
                }
                notes.append(Note.init(id: id,
                                       title: title,
                                       textBody: textBody,
                                       timeStamp: timeStamp))
            }
        } catch let error as NSError {
            assertionFailure("Could not fetch notes from CoreData: \(error), \(error.userInfo)")
        }
        return notes
    }

    // MARK: - Core Data Deleting support
    

}
