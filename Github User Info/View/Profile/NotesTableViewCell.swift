//
//  NotesTableViewCell.swift
//  Github User Info
//
//  Created by Ram on 25/06/24.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    static let identifier = "NotesTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "NotesTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
