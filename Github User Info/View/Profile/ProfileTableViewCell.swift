//
//  ProfileTableViewCell.swift
//  Github User Info
//
//  Created by Ram on 25/06/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: UserProfileViewModel) {
        let profile = viewModel.getProfile()
        
        viewModel.getAvatar(url: profile?.avatar_url ?? "") { [weak self] image in
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }
        followersCountLabel.text = "\(profile?.followers ?? 0)"
        followingCountLabel.text = "\(profile?.following ?? 0)"
    }
        
    
}
