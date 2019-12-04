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
    @IBOutlet private weak var noteBodyLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.text = "Note Text"
        }
    }
    @IBOutlet private weak var noteBodyTextView: UITextView! {
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
        noteBodyTextView.delegate = self

        initialSetup()
        configureView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      noteBodyTextView.contentOffset = .zero
    }
    
    private func initialSetup() {
        navigationItem.rightBarButtonItem = nil
        noteTitleTextField.text = ""
        noteBodyTextView.text = ""
    }
    
    private func configureView() {
        if let note = note {
            if let titleLabel = noteTitleTextField, let textViewDescription = noteBodyTextView {
                titleLabel.text = note.title
                textViewDescription.text = note.textBody
            }
        }
    }
    
    private func showDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveNoteToCoreData))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func saveNoteToCoreData() {
        prepareToSaveNote()
        saveNote()
    }
    
    private func prepareToSaveNote() {
        noteTitleTextField.resignFirstResponder()
        noteBodyTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    private func saveNote() {
        if let noteTitleText = noteTitleTextField.text,
            let noteBodyText = noteBodyTextView.text {
            if noteTitleText.isEmpty && noteBodyText.isEmpty {
                showAlert(title: "Your note cannot be empty.", text: "Please add a title or a text body of your note ;)")
            } else {
                let note = Note(title: noteTitleText, textBody: noteBodyText)
                NoteStorageManager.shared.saveNote(note: note)
            }
        
        }
    }
    
    private func showAlert(title: String, text: String) {
        // TODO: improve implementation
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == noteTitleTextField {
            noteBodyTextView.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 35
    }
}


