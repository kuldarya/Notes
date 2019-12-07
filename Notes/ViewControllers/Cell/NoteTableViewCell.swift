//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.textColor = .black
        }
    }
    
    @IBOutlet weak var textBodyLabel: UILabel! {
        willSet {
            newValue.font = .systemFont(ofSize: 14)
            newValue.textColor = .gray
        }
    }
    
    @IBOutlet weak var timeStampLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 14)
            newValue.textColor = .gray
        }
    }
    
    var note: Note? {
        didSet {
            if let note = note {
                titleLabel.text = note.noteTitle
                
                if note.noteTextBody.isEmpty {
                    textBodyLabel.text = "No additional text"
                } else {
                    textBodyLabel.text = note.noteTextBody
                }
                
                timeStampLabel.text = note.noteTimeStamp.toString()
            }
        }
    }
}
