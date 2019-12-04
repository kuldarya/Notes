//
//  NoteCell.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

final class NoteCell: UITableViewCell {
    @IBOutlet weak var noteTitle: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.textColor = .black
        }
    }
    
    @IBOutlet weak var noteBodyText: UILabel! {
        willSet {
            newValue.font = .systemFont(ofSize: 14)
            newValue.textColor = .gray
        }
    }
    
    @IBOutlet weak var noteDate: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 14)
            newValue.textColor = .gray
        }
    }
    
    var note: Note? {
        didSet {
            if let note = note {
                noteTitle.text = note.title
                
                if note.textBody.isEmpty {
                    noteBodyText.text = "No additional text"
                } else {
                    noteBodyText.text = note.textBody
                }
                
                noteDate.text = note.date.toString()
            }
        }
    }
}
