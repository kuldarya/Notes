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
    var count = 0
    
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
    
    func saveNoteToCoreData(note: Note, managedContext: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: managedContext) else {
            assertionFailure()
            return
        }
        let newNote = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newNote.setValue(note.id, forKey: "id")
        newNote.setValue(note.title, forKey: "title")
        newNote.setValue(note.textBody, forKey: "textBody")
        newNote.setValue(note.date, forKey: "date")
        
        do {
            try CoreDataManager.shared.saveContext()
            count += 1
        } catch let error as NSError {
            assertionFailure("Could not save note to CoreData: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Core Data Fetching support
    
    func fetchAllNotes(managedContext: NSManagedObjectContext) -> [Note] {
        var notes = [Note]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let fetchedNotes = try managedContext.fetch(fetchRequest)
            
            fetchedNotes.forEach { result in
                let noteEntity = result as! NSManagedObject
                notes.append(Note.init(id: noteEntity.value(forKey: "id") as! UUID,
                                       title: noteEntity.value(forKey: "title") as! String,
                                       textBody: noteEntity.value(forKey: "textBody") as! String,
                                       date: noteEntity.value(forKey: "date") as! Date))
            }
        } catch let error as NSError {
            assertionFailure("Could not fetch notes from CoreData: \(error), \(error.userInfo)")
        }
        count = notes.count
        return notes
    }
    
    func fetchNote(noteId: UUID, managedContext: NSManagedObjectContext) -> Note? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        let noteIdPredicate = NSPredicate(format: "id = %@", noteId as CVarArg)
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let notesFromCoreData = try managedContext.fetch(fetchRequest)
            let noteManagedObject = notesFromCoreData[0] as! NSManagedObject
            return Note.init(id: noteManagedObject.value(forKey: "id") as! UUID,
                             title: noteManagedObject.value(forKey: "title" ) as! String,
                             textBody: noteManagedObject.value(forKey: "textBody") as! String,
                             date: noteManagedObject.value(forKey: "date") as! Date)
        } catch let error as NSError {
            assertionFailure("Note cannot be fetched from CoreData: \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: - Core Data Deleting support
    
    func deleteNote(noteId: UUID, managedContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        let noteCVarArg = noteId as CVarArg
        let noteIdPredicate = NSPredicate(format: "id == %@", noteCVarArg)
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let notesFromCoreData = try managedContext.fetch(fetchRequest)
            let noteToDelete = notesFromCoreData[0] as! NSManagedObject
            managedContext.delete(noteToDelete)
            
            do {
                try CoreDataManager.shared.saveContext()
                count -= 1
            } catch let error as NSError {
                assertionFailure("Could not save changes to CoreData: \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            assertionFailure("Could not delete object from CoreDara: \(error), \(error.userInfo)")
        }
    }
}
