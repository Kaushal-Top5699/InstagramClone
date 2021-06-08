//
//  StoryCell.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 04/06/21.
//

import UIKit

class StoryCell: UICollectionViewCell {

    @IBOutlet weak var storyImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        storyImageView.layer.borderWidth = 0.5
        storyImageView.layer.masksToBounds = false
        storyImageView.layer.borderColor = UIColor.darkGray.cgColor
        storyImageView.layer.cornerRadius = storyImageView.frame.height/2
        storyImageView.clipsToBounds = true
        
    }

}
