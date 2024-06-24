import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDetailsLabel: UILabel!
    
    static let identifier = "UserTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "UserTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        userNameImage.layer.cornerRadius = userNameImage.bounds.width / 2
        userNameImage.clipsToBounds = true
        userNameImage.contentMode = .scaleAspectFill
        userNameImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: UserListViewModel, index: Int) {
        let user = viewModel.user(at: index)
        userNameLabel.text = user.login
        userDetailsLabel.text = user.type
        
        // Clear previous image to avoid flickering
        userNameImage.image = nil
        
        // Fetch avatar asynchronously
        viewModel.getAvatar(url: user.avatar_url ?? "") { [weak self] image in
            DispatchQueue.main.async {
                self?.userNameImage.image = image
            }
        }
    }
}
