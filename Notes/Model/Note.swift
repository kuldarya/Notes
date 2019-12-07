//
//  Note.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation

final class Note {
    let noteId: UUID
    let noteTitle: String
    let noteTextBody: String
    let noteTimeStamp: Date
    
    init(noteId: UUID, noteTitle: String, noteTextBody: String, noteTimeStamp: Date) {
        self.noteId = noteId
        self.noteTitle = noteTitle
        self.noteTextBody = noteTextBody
        self.noteTimeStamp = noteTimeStamp
    }
    
    init(noteTitle: String, noteTextBody: String) {
        self.noteId = UUID()
        self.noteTitle = noteTitle
        self.noteTextBody = noteTextBody
        self.noteTimeStamp = Date()
    }
}
