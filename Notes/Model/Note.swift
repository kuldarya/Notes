//
//  Note.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation

class Note {
    let noteId: UUID
    let noteTitle: String
    let noteBody: String
    let noteTimeStamp: Date
    
    init(noteId: UUID, noteTitle: String, noteBody: String, noteTimeStamp: Date) {
        self.noteId = noteId
        self.noteTitle = noteTitle
        self.noteBody = noteBody
        self.noteTimeStamp = noteTimeStamp
    }
    
    init(noteTitle: String, noteBody: String) {
        self.noteId = UUID()
        self.noteTitle = noteTitle
        self.noteBody = noteBody
        self.noteTimeStamp = Date()
    }
}
