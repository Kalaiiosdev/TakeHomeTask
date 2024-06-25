//
//  BioDataTableViewCell.swift
//  Github User Info
//
//  Created by Ram on 25/06/24.
//

import UIKit

class BioDataTableViewCell: UITableViewCell {
    
    static let identifier = "BioDataTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "BioDataTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with title: String, value: String) {
        self.titleLabel.text = title
        self.valueLabel.text = value
    }
    
}
