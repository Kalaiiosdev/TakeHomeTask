//
//  UserProfileDetailViewController.swift
//  Github User Info
//
//  Created by Ram on 21/06/24.
//

import UIKit

class UserProfileDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, NotesTableViewCellDelegate {
    
    
    private let viewModel = UserProfileViewModel()
    var userName: String?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProfileTableViewCell.nib(), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.register(BioDataTableViewCell.nib(), forCellReuseIdentifier: BioDataTableViewCell.identifier)
        tableView.register(NotesTableViewCell.nib(), forCellReuseIdentifier: NotesTableViewCell.identifier)
        if let username = userName {
            viewModel.fetchProfile(username: username)
        }
        // Bind ViewModel
        viewModel.onProfileUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.title = self?.viewModel.profile?.name
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { error in
            // Handle error
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                tableView.contentInset = contentInsets
                tableView.scrollIndicatorInsets = contentInsets
            }
        }

        @objc func keyboardWillHide(notification: Notification) {
            let contentInsets = UIEdgeInsets.zero
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return viewModel.profileData.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            cell.configure(with: viewModel)
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BioDataTableViewCell.identifier, for: indexPath) as! BioDataTableViewCell
            let profileItem = viewModel.profileData[indexPath.row]
            cell.configure(with: profileItem.0, value: profileItem.1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
            cell.delegate = self
            cell.configure(with: viewModel.profile?.userNote ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 64
        }else if indexPath.section == 2{
            return 240
        }else {
            return 168
        }
    }
    
    func didUpdateNotes(_ cell: NotesTableViewCell, notes: String) {
        // Update the view model with the new notes
        if let username = userName {
            viewModel.saveNotes(username: username, note: notes)
            showNotesSavedAlert()
        }
    }
    
    func showNotesSavedAlert() {
        let alertController = UIAlertController(title: "Success", message: "Your notes have been saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
