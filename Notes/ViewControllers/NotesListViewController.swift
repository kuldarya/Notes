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

    var notes = Note.getDefaultData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        createAddButton()
    }
    
    private func createAddButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnAddButton))
    }
    
    @objc private func didTapOnAddButton() {
        /// push to the empty VC with textView
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

