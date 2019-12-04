//
//  Note.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation

class Note {
    private(set) var id: UUID
    private(set) var title: String
    private(set) var textBody: String
    private(set) var date: Date
    
    init(title: String, textBody: String, date: Date) {
        self.id = UUID()
        self.title = title
        self.textBody = textBody
        self.date = date
    }
    
    init(id: UUID, title: String, textBody: String, date: Date) {
        self.id = id
        self.title = title
        self.textBody = textBody
        self.date = date
    }
    
    init(title: String, textBody: String) {
        self.id = UUID()
        self.title = title
        self.textBody = textBody
        self.date = Date()
    }
}
