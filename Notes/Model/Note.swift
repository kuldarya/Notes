//
//  Note.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import Foundation

class Note {
    var title: String
    var description: String
    var date: Date
    
    init(title: String, description: String, date: Date) {
        self.title = title
        self.description = description
        self.date = date
    }
    
    /// TODO: remove later
    public class func getDefaultData() -> [Note] {
        return [
            Note(title: "Lorem ipsum dolor sit amet", description: "Lorem ipsum dolor sit amet", date: Date(timeIntervalSinceReferenceDate: -123456789.0)),
                Note(title: "Pri ex dolor everti", description: "Lorem ipsum dolor sit amet", date: Date(timeIntervalSinceReferenceDate: -123456789.0)),
                Note(title: "Est utroque", description: "Lorem ipsum dolor sit amet", date: Date(timeIntervalSinceReferenceDate: -123456789.0)),
                Note(title: "Vis ea prima viderer.", description: "Lorem ipsum dolor sit amet", date: Date(timeIntervalSinceReferenceDate: -123456789.0))
        ]
    }
}
