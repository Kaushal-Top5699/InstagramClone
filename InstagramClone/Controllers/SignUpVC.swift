//
//  SignUpVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 03/06/21.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    @IBAction func createUserBtn(_ sender: UIButton) {
        
        let username = usernameText.text!
        let email = emailText.text!
        let password = passwordText.text!
        
        if username != "" && email != "" && password != "" {
            
            let URL = "http://localhost:3000/signup"
            let parameters: [String: String] = [
                "username": username,
                "email": email,
                "password": password
            ]
            
            AF.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    let myBody = response.value as! Dictionary<String, Any>
                    let userToken = myBody["token"] as! String
                    UserDefaults.standard.setValue(userToken, forKey: "token")
                    
                    let statusCode: Int = response.response!.statusCode
                    if statusCode == 200 {
                        print("User created")
                    } else {
                        print(statusCode)
                    }
                    
                }
            
        } else {
            displayAlert(title: "Error", message: "username, email, password not found", btnTitle: "I understand")
        }
        
    }
    
    @IBAction func backToLoginBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func setUpView() {
        usernameView.layer.borderWidth = 0.3
        usernameView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        usernameView.layer.backgroundColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)
        usernameView.layer.cornerRadius = 6
        
        emailView.layer.borderWidth = 0.3
        emailView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        emailView.layer.backgroundColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)
        emailView.layer.cornerRadius = 6
        
        passwordView.layer.borderWidth = 0.3
        passwordView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        passwordView.layer.backgroundColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)
        passwordView.layer.cornerRadius = 6
        
        createButton.layer.cornerRadius = 6
    }
    
    private func displayAlert(title: String, message: String, btnTitle: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertButton = UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default) { UIAlertAction in
            //Perform you action after button is press
        }
        alert.addAction(alertButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}
