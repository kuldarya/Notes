//
//  NotesListViewController.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

final class NotesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NoteStorageManager.shared.setManagedContext(managedObjectContext: CoreDataManager.shared.managedContext)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //TODO: show fresh notes at top
        notes = CoreDataManager.shared.fetchAllNotes(managedContext: CoreDataManager.shared.managedContext)
        
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnCreateButton))
    }
    
    @objc private func didTapOnCreateButton() {
        guard let controller = UIStoryboard.mainStoryboard?.instantiateVC(NoteDetailsViewController.self) else {
            assertionFailure()
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
        // TODO: изменение текущей заметки создает новую, а не модифицирует старую, общий каунт растет
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.className, for: indexPath) as? NoteTableViewCell else {
            assertionFailure()
            return UITableViewCell()
        }
        
        if let object = NoteStorageManager.shared.loadNote(at: indexPath.row) {
            if object.noteTitle.isEmpty {
                cell.titleLabel.text = "No title"
            } else {
                cell.titleLabel.text = object.noteTitle
            }
            
            if object.noteTextBody.isEmpty {
                cell.textBodyLabel.text = "No additional text"
            } else {
                cell.textBodyLabel.text = object.noteTextBody
            }
            
            cell.timeStampLabel.text = object.noteTimeStamp.toString()
        }
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard.mainStoryboard?.instantiateVC(NoteDetailsViewController.self) else {
            assertionFailure()
            return
        }
        let object = NoteStorageManager.shared.loadNote(at: indexPath.row)
        controller.note = object
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NoteStorageManager.shared.deleteNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

