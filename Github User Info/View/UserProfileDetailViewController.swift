//
//  UserProfileDetailViewController.swift
//  Github User Info
//
//  Created by Ram on 21/06/24.
//

import UIKit

class UserProfileViewController: UIViewController {
    var username: String = ""
    private let viewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch profile
        viewModel.fetchProfile(username: username)
       
        // Bind ViewModel
        viewModel.onProfileUpdated = { [weak self] in
            DispatchQueue.main.async {
                
            }
        }
        
        viewModel.onError = { error in
            // Handle error
        }
        
       
    }
}
