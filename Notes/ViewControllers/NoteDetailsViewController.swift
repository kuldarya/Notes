//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit
import Rswift

final class NoteDetailsViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.text = R.string.localizable.noteTitle()
        }
    }
    @IBOutlet private weak var titleTextField: UITextField! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.textColor = .black
            newValue.delegate = self
        }
    }
    @IBOutlet private weak var textBodyLabel: UILabel! {
        willSet {
            newValue.font = .boldSystemFont(ofSize: 16)
            newValue.text = R.string.localizable.noteText()
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
            
            newValue.delegate = self
        }
    }
    
    private let animationDuration = 0.25
    
    var note: Note?
    
    private lazy var doneButton = UIBarButtonItem(title: R.string.localizable.done(),
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(saveNoteToCoreData))
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configureView()
        subscribeToKeyboardNotifications()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDoneButton()
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
    
    //MARK: - IBActions
    
    @IBAction private func textFieldTextDidChange(_ sender: UITextField) {
        updateDoneButton()
    }

    //MARK: - Setup
    
    private func configureView() {
        if let note = note {
            titleTextField.text = note.title
            textBodyTextView.text = note.textBody
        }
    }
    
    private func setDoneButton() {
        navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
    }
    
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: animationDuration) {
            self.scrollViewBottomConstraint.constant = -keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: animationDuration) {
            self.scrollViewBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func saveNoteToCoreData() {
        resetBeforeSaving()
        saveNote()
    }
    
    private func resetBeforeSaving() {
        titleTextField.resignFirstResponder()
        textBodyTextView.resignFirstResponder()
        doneButton.isEnabled = false
    }
    
    private func saveNote() {
        guard let noteTitle = titleTextField.text,
            let noteBodyText = textBodyTextView.text,
            (!noteTitle.isEmpty || !noteBodyText.isEmpty) else {
                if let note = note {
                    NoteStorageManager.shared.deleteNote(note: note)
                }
            return
        }
        if let note = note {
            note.title = noteTitle
            note.textBody = noteBodyText
            NoteStorageManager.shared.saveNote(note: note)
        } else {
            let note = Note(title: noteTitle, textBody: noteBodyText)
            NoteStorageManager.shared.saveNote(note: note)
        }
    }
    
    private func updateDoneButton() {
        guard let titletextField = titleTextField.text else {
            return
        }
        let isTextFieldEmpty = titletextField.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isTextViewEmpty = textBodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        doneButton.isEnabled = !isTextFieldEmpty || !isTextViewEmpty
    }
}

extension NoteDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            textBodyTextView.becomeFirstResponder()
        }
        return true
    }
}

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDoneButton()
    }
}
