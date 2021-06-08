//
//  DetailsVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 07/06/21.
//

import UIKit
import Alamofire

class DetailsVC: UIViewController {

    var choosenUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserInfo()
        
    }
    
    private func fetchUserInfo() {
        
        let URL = "http://localhost:3000/view-user"
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        if storedToken != nil {
            
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
            ]
            let parameter: [String:String] = [
                "_id": choosenUID
            ]
            
            AF.request(URL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    
                    if let body = response.value as? Dictionary<String, Any> {
                        
                        print(body["username"] as! String)
                        print(body["bio"] as! String)
                        
                    }
                    
                }
            
        } else {
            print("Authentication Required")
        }
        
    }
    

    @IBAction func closeBtn(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
