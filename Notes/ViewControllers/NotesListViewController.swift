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
        
        //TODO: ?
        NoteStorageManager.shared.setManagedContext(managedObjectContext: CoreDataManager.shared.managedContext)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        notes = CoreDataManager.shared.fetchAllNotes(managedContext: CoreDataManager.shared.managedContext)
        
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnCreateButton))
    }
    
    @objc private func didTapOnCreateButton() {
        performSegue(withIdentifier: "openNote", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNote" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as? NoteDetailsViewController
                controller?.note = notes[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            NoteStorageManager.shared.deleteNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

