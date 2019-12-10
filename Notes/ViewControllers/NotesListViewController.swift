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
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            
        notes = CoreDataManager.shared.fetchNotes()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnCreateButton))
    }
    
    @objc private func didTapOnCreateButton() {
        performSegue(withIdentifier: "openNote", sender: self)
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
        performSegue(withIdentifier: "openNote", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, success: @escaping (Bool) -> Void) in
            self.performSegue(withIdentifier: "openNote", sender: indexPath)
            success(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success: @escaping (Bool) -> Void) in
            CoreDataManager.shared.deleteNote(note: self.notes[indexPath.row])
            self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            success(true)
        }
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
}

