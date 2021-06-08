//
//  UserCell.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 07/06/21.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userBox: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.borderWidth = 0.5
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.darkGray.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
