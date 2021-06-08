//
//  PostModelTwo.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 08/06/21.
//

import Foundation
import UIKit
class PostModelTwo {
    
    let username: String
    let caption: String
    let date: String
    let postLikes: String
    var image: String
    
    init(username: String, caption: String, date: String, postLikes: String, image: String) {
        self.username = username
        self.caption = caption
        self.date = date
        self.postLikes = postLikes
        self.image = image
    }
    
}
