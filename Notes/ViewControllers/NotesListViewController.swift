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
    let managedContext = CoreDataManager.shared.managedContext
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NoteStorageManager.shared.setManagedContext(managedObjectContext: managedContext)
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // TODO: loadNotesFromCoreData()
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.className, for: indexPath) as? NoteCell else {
            assertionFailure()
            return UITableViewCell()
        }
        
        cell.note = notes[indexPath.item]
       
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard.mainStoryboard?.instantiateVC(NoteDetailsViewController.self) else {
            assertionFailure()
            return
        }
        controller.note = notes[indexPath.item]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

