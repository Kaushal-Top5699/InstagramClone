//
//  UserModel.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 07/06/21.
//

import Foundation
import UIKit

struct UserModel {
    
    let username: String
    let profileImage: String
    let UID: String
    
    init(username: String, profileImage: String, UID: String) {
        self.username = username
        self.profileImage = profileImage
        self.UID = UID
    }
}
