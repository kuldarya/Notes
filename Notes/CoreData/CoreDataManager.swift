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
            print("Could not save to CoreData. \(error), \(error.userInfo)")
        }
    }
    
    func loadNotesFromCoreData(managedContext: NSManagedObjectContext) -> [Note] {
        var returnedNotes = [Note]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        
        do {
            let fetchedNotesFromCoreData = try managedContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { fetchRequestResult in
                let noteEntity = fetchRequestResult as! NSManagedObject
                returnedNotes.append(Note.init(id: noteEntity.value(forKey: "id") as! UUID,
                                               title: noteEntity.value(forKey: "title") as! String,
                                               textBody: noteEntity.value(forKey: "textBody") as! String,
                                               date: noteEntity.value(forKey: "date") as! Date))
            }
        } catch let error as NSError {
            print("Could not read. \(error), \(error.userInfo)")
        }
        count = returnedNotes.count
        return returnedNotes
    }
}

