//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

final class NoteDetailsViewController: UIViewController {
    @IBOutlet private weak var noteTitle: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.textColor = .black
            newValue.numberOfLines = 0
        }
    }
    
    @IBOutlet private weak var noteDate: UILabel! {
        willSet {
            newValue.font = .systemFont(ofSize: 13)
            newValue.textColor = .gray
        }
    }
    
    @IBOutlet private weak var noteDescription: UITextView! {
        willSet {
            newValue.font = .systemFont(ofSize: 14)
            newValue.textColor = .black
        }
    }
    
    var noteDetails: Note? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
    
    func configureView() {
        if let note = noteDetails {
            if let titleLabel = noteTitle, let dateLabel = noteDate, let textViewDescription = noteDescription {
                titleLabel.text = note.title
                dateLabel.text = note.date.toString(dateFormat: "dd-MM-yyyy")
                textViewDescription.text = note.description
            }
        }
    }
    
    
}
