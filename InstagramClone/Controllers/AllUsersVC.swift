//
//  AllUsersVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 07/06/21.
//

import UIKit
import Alamofire

class AllUsersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var usersArray = [UserModel]()
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        fetchUsers()
        
    }

    
    private func fetchUsers() {
        
        let URL = "http://localhost:3000/all-users"
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        if storedToken != nil {
            
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
            ]
            
//            var image = UIImage()
            
            AF.request(URL, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    
                    if let myBody = response.value as? Array<Dictionary<String, Any>> {
                        
                        for body in myBody {
                            let username = body["username"]
                            let profileImageURL = body["profileImage"]
                            let userID = body["_id"]
                            self.usersArray.append(UserModel(username: username as! String, profileImage: profileImageURL as! String, UID: userID as! String))
                        }
                        
                    } else if let body = response.value as? Dictionary<String, Any> {
                        let username = body["username"]
                        let profileImageURL = body["profileImage"]
                        let userID = body["_id"]
                        self.usersArray.append(UserModel(username: username as! String, profileImage: profileImageURL as! String, UID: userID as! String))
                    }
                    self.tableView.reloadData()
                }
            
        } else {
            print("Authentication Required")
            return
        }
        
    }
    
    private func downloadImage(urlString: String) -> UIImage? {
        var image = UIImage()
        let donwloadURL = NSURL(string: urlString)
        if let data = try? Data(contentsOf: donwloadURL! as URL) {
            image = UIImage(data: data)!
            return image
        }
        return nil
    }
}

//MARK: - UITableViewDataSource
extension AllUsersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.usersArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        cell.usernameLabel.text = user.username
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension AllUsersVC: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.choosenUID = userId
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = usersArray[indexPath.row]
        userId = user.UID
        //print("AllUserVC: \(userId)")
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}
