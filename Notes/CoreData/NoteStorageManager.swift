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
    
    func saveNote(note: Note) {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(NoteEntity.id)) == %@", argumentArray: [note.id])
        if let savedNote = try? CoreDataManager.shared.managedContext.fetch(request).first {
            savedNote.title = note.title
            savedNote.textBody = note.textBody
        } else {
            _ = NoteEntity(note: note, context: CoreDataManager.shared.managedContext)
        }
        
        do {
            try CoreDataManager.shared.saveContext()
        } catch let error as NSError {
            assertionFailure("Could not save note to CoreData: \(error), \(error.userInfo)")
        }
    }
    
    func fetchNotes() -> [Note] {
        var notes = [Note]()
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        let sortDescriptor = [NSSortDescriptor(key: #keyPath(NoteEntity.timeStamp), ascending: false)]
        request.sortDescriptors = sortDescriptor
        
        do {
            let fetchedNotes = try CoreDataManager.shared.managedContext.fetch(request)
            notes = fetchedNotes.map { .init(noteEntity: $0) }
        } catch let error as NSError {
            assertionFailure("Could not fetch notes from CoreData: \(error), \(error.userInfo)")
        }
        return notes
    }
    
    func deleteNote(note: Note) {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(NoteEntity.id)) == %@", argumentArray: [note.id])
        
        do {
            let notes = try CoreDataManager.shared.managedContext.fetch(request)
            for note in notes {
                CoreDataManager.shared.managedContext.delete(note)
            }
        } catch let error as NSError {
            assertionFailure("Could not fetch notes from CoreData: \(error), \(error.userInfo)")
        }
        
        do {
            try CoreDataManager.shared.saveContext()
        } catch let error as NSError {
            assertionFailure("Could not save notes to CoreData: \(error), \(error.userInfo)")
        }
    }
}
