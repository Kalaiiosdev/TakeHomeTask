//
//  UserProfileDetailViewController.swift
//  Github User Info
//
//  Created by Ram on 21/06/24.
//

import UIKit

class UserProfileDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
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
            //cell.configure(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 168
        }else if indexPath.section == 1{
            return 48
        }else {
            return 64
        }
    }
}

//  "name": "Chris Wanstrath",
//  "company": null,
//  "blog": "http://chriswanstrath.com/",
//  "location": null,
//  "email": null,
//  "hireable": null,
//  "bio": "🍔",
//  "twitter_username": null,
//  "public_repos": 107,
//  "public_gists": 274,
