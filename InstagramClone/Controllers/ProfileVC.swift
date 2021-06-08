//
//  ProfileVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 03/06/21.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameTOPLabel: UILabel!
    @IBOutlet weak var usernameBOTTOMLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserProfile()
    }

    
    @IBAction func editProfileBtn(_ sender: UIButton) {
        
        
        
    }
    
    private func fetchUserProfile() {
        
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        if storedToken != nil {
         
            let URL = "http://localhost:3000/me"
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
              ]
            
            AF.request(URL, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    
                    let statusCode: Int = response.response!.statusCode
                    print(statusCode)
                    
                    if statusCode == 200 {
                        let myBody = response.value as! Dictionary<String, Any>
                        let username = myBody["username"] as! String
                        let bio = myBody["bio"] as! String
                        let posts = myBody["posts"] as! Int
                        let followers = myBody["followers"] as! Array<Any>
                        let following = myBody["following"] as! Array<Any>
                        
                        self.usernameTOPLabel.text = " \(username)"
                        self.usernameBOTTOMLabel.text = username
                        self.bioLabel.text = bio
                        self.postNumberLabel.text = String(posts)
                        self.followersLabel.text = String(followers.count)
                        self.followingLabel.text = String(following.count)
                        print("Profile Fetched!!")
                    } else {
                        print("ERROR")
                    }
                }
            
        } else {
            print("Authentication Required")
        }
    }
    
    private func setupUI() {
        editButton.layer.borderWidth = 0.3
        editButton.layer.cornerRadius = 3
        
        profileImageView.layer.borderWidth = 0.3
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
}
