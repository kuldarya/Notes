//
//  Note.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation

final class Note {
    let id: UUID
    var title: String?
    var textBody: String?
    var timeStamp: Date
    
    init(title: String, textBody: String) {
        self.id = UUID()
        self.title = title
        self.textBody = textBody
        self.timeStamp = Date()
    }
    
    init(noteEntity: NoteEntity) {
        self.id = noteEntity.id
        self.title = noteEntity.title
        self.textBody = noteEntity.textBody
        self.timeStamp = noteEntity.timeStamp
    }
}
