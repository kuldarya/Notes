//
//  NoteCell.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

final class NoteCell: UITableViewCell {
    @IBOutlet private weak var noteTitle: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.textColor = .black
        }
    }
    
    @IBOutlet private weak var noteBodyText: UILabel! {
        willSet {
            newValue.font = .systemFont(ofSize: 14)
            newValue.textColor = .gray
        }
    }
    
    @IBOutlet private weak var noteDate: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 14)
            newValue.textColor = .gray
        }
    }
    
    var note: Note? {
        didSet {
            noteTitle.text = note?.title
            noteBodyText.text = note?.description
            noteDate.text = note?.date.toString(dateFormat: "dd-MM")
        }
    }
}
