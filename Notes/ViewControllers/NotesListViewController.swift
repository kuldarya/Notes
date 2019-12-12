//
//  NotesListViewController.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/3/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit
import Rswift

final class NotesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    private var notes = [Note]()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        NoteStorageManager.shared.fetchNotes { result in
            switch result {
            case .success(let notes):
                self.notes = notes
            case .failure(_):
                break
                //TODO: show alert
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.title = R.string.localizable.notes()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnCreateButton))
    }
    
    @objc private func didTapOnCreateButton() {
        performSegue(withIdentifier: R.segue.notesListViewController.openNote, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNote" {
            if let indexPath = sender as? NSIndexPath {
                let controller = segue.destination as? NoteDetailsViewController
                controller?.note = notes[indexPath.row]
            }
        }
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.className, for: indexPath) as? NoteTableViewCell else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.note = notes[indexPath.item]
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.notesListViewController.openNote, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NoteStorageManager.shared.deleteNote(note: notes[indexPath.row])
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

