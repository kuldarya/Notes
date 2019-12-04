//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

final class NoteDetailsViewController: UIViewController {
    @IBOutlet private weak var noteTitleLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.text = "Note Title"
        }
    }
    @IBOutlet private weak var noteTitleTextField: UITextField! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.textColor = .black
        }
    }
    @IBOutlet private weak var noteDescriptionLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.text = "Note Text"
        }
    }
    @IBOutlet private weak var noteDescriptionTextView: UITextView! {
        willSet {
            newValue.font = .systemFont(ofSize: 16)
            newValue.textColor = .black
            newValue.layer.borderColor = UIColor.lightGray.cgColor
            newValue.layer.borderWidth = 1
            newValue.clipsToBounds = true
            newValue.layer.cornerRadius = 10.0

        }
    }
    
    var note: Note? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        noteTitleTextField.delegate = self
        noteDescriptionTextView.delegate = self

        initialSetup()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      noteDescriptionTextView.contentOffset = .zero
    }
    
    private func initialSetup() {
        navigationItem.rightBarButtonItem = nil
        noteTitleTextField.text = ""
        noteDescriptionTextView.text = ""
    }
    
    private func configureView() {
        if let note = note {
            if let titleLabel = noteTitleTextField, let textViewDescription = noteDescriptionTextView {
                titleLabel.text = note.title
                textViewDescription.text = note.textBody
            }
        }
    }
    
    private func showDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(prepareToSaveToCoreData))
        navigationItem.rightBarButtonItem = doneButton
    }
        
    @objc func prepareToSaveToCoreData() {
        noteTitleTextField.resignFirstResponder()
        noteDescriptionTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        
        ///save to coredata
    }
}

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        showDoneButton()
    }
}

extension NoteDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDoneButton()
    }
}


