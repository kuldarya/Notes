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
    var title: String
    var textBody: String
    var timeStamp: Date
    
    init(id: UUID, title: String, textBody: String, timeStamp: Date) {
        self.id = id
        self.title = title
        self.textBody = textBody
        self.timeStamp = timeStamp
    }
    
    init(title: String, textBody: String) {
        self.id = UUID()
        self.title = title
        self.textBody = textBody
        self.timeStamp = Date()
    }
}
