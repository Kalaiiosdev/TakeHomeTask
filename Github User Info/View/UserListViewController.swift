//
//  ViewController.swift
//  Github User Info
//
//  Created by Ram on 21/06/24.
//

import UIKit

class UserListViewController: UIViewController {
    private let viewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch users
        viewModel.fetchUsers()
       
        // Bind ViewModel
        viewModel.onUsersUpdated = { [weak self] in
            DispatchQueue.main.async {
                // Reload your table view or collection view here
            }
        }
        
        viewModel.onError = { error in
            // Handle error
        }
    }
}
