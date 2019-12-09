//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

final class NoteDetailsViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.text = "Note Title"
        }
    }
    @IBOutlet private weak var titleTextField: UITextField! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.textColor = .black
        }
    }
    @IBOutlet private weak var textBodyLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.text = "Note Text"
        }
    }
    @IBOutlet private weak var textBodyTextView: UITextView! {
        willSet {
            newValue.font = .systemFont(ofSize: 16)
            newValue.textColor = .black
            newValue.layer.borderColor = UIColor.lightGray.cgColor
            newValue.layer.borderWidth = 1
            newValue.clipsToBounds = true
            newValue.layer.cornerRadius = 10.0
        }
    }
    
    var note: Note?
    
    //TODO: what's the best way?
    private var doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveNoteToCoreData))
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        textBodyTextView.delegate = self
        
        initialSetup()
        configureView()
        
        subscribeToKeyboardNotifications()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Keyboard Observers
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNotification(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideNotification(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    //MARK: - Setup
    
    private func initialSetup() {
        navigationItem.rightBarButtonItem = nil
        titleTextField.text = ""
        textBodyTextView.text = ""
    }
    
    private func configureView() {
        if let note = note {
            titleTextField.text = note.noteTitle
            textBodyTextView.text = note.noteTextBody
        }
    }
    
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        textBodyTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        textBodyTextView.scrollIndicatorInsets = textBodyTextView.contentInset
        textBodyTextView.scrollRangeToVisible(textBodyTextView.selectedRange)
    }

    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        view.endEditing(true)
    }
    
    @objc private func saveNoteToCoreData() {
        prepareToSaveNote()
        saveNote()
    }
    
    private func prepareToSaveNote() {
        titleTextField.resignFirstResponder()
        textBodyTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    private func saveNote() {
        //TODO: не эдитит текущую, а создает каждый раз новую!!!
        if let noteTitleText = titleTextField.text,
            let noteBodyText = textBodyTextView.text {
            if noteTitleText.isEmpty && noteBodyText.isEmpty {
                showAlert(title: "Your note cannot be empty.", text: "Please add a title or a text body of your note ;)")
            } else {
                let note = Note(noteTitle: noteTitleText, noteTextBody: noteBodyText)
                NoteStorageManager.shared.saveNote(note: note)
            }
        }
    }
    
    private func showAlert(title: String, text: String) {
        // TODO: improve implementation
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = doneButton
    }
}

extension NoteDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            textBodyTextView.becomeFirstResponder()
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
