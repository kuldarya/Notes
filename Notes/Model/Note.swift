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
    
    //TODO: add noteID
    init(title: String, textBody: String, date: Date) {
        self.id = UUID()
        self.title = title
        self.textBody = textBody
        self.date = date
    }
    
    /// TODO: remove later
    public class func getDefaultData() -> [Note] {
        return [
            Note(title: "Lorem ipsum dolor sit amet", textBody: "Lorem ipsum dolor sit amet Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam lib Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam lib Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam lib", date: Date(timeIntervalSinceReferenceDate: -123456789.0)),
                Note(title: "Pri ex dolor everti", textBody: "Lorem ipsum dolor sit amet", date: Date(timeIntervalSinceReferenceDate: -123456789.0)),
                Note(title: "Est utroque", textBody: "Lorem ipsum dolor sit amet", date: Date(timeIntervalSinceReferenceDate: -123456789.0)),
                Note(title: "Vis ea prima viderer.", textBody: "Lorem ipsum dolor sit amet", date: Date(timeIntervalSinceReferenceDate: -123456789.0))
        ]
    }
}
