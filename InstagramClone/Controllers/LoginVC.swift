//
//  ViewController.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 03/06/21.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiDesignSetup()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storedToken = UserDefaults.standard.object(forKey: "token")
        if storedToken != nil {
            print("Logged In")
            performSegue(withIdentifier: "toHomeVC", sender: self)
            
        } else {
            print("User not logged in")
        }
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toSignUpVC", sender: self)
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        let email = emailText.text
        let password = passwordText.text
        
        if email != "" && password != "" {
            let URL = "http://localhost:3000/login"
            let parameters: [String: String] = [
                "email": email!,
                "password": password!
            ]
            
            AF.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    let statusCode: Int = response.response!.statusCode
                    print(statusCode)
                    
                    if statusCode == 200 {
                        let myBody = response.value as! Dictionary<String, Any>
                        let userToken = myBody["token"] as! String
                        UserDefaults.standard.setValue(userToken, forKey: "token")
                        print("Token Saved")
                        self.performSegue(withIdentifier: "toHomeVC", sender: self)
                        print("User Logged In")
                    }
                }
        } else {
            displayAlert(title: "Error", message: "Email or Password not found", btnTitle: "I understand")
        }
    }
    
    
    //******** ******** ******** ******** ******** ******** ******** ********
    //Logout button for testing
    @IBAction func continueFacebookBtn(_ sender: UIButton) {
        
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        if storedToken != nil {
            
            let URL = "http://localhost:3000/logout"
            
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
              ]
            
            AF.request(URL, method: .post, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let statusCode: Int = response.response!.statusCode
                    if statusCode == 200 {
                        print(statusCode)
                        UserDefaults.standard.removeObject(forKey: "token")
                    } else {
                        print(statusCode)
                    }
                }
            
        } else {
            print("Authentication Required")
        }
    }
    
    private func uiDesignSetup() {
        emailView.layer.borderWidth = 0.3
        emailView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        emailView.layer.backgroundColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)
        emailView.layer.cornerRadius = 6

        passwordView.layer.borderWidth = 0.3
        passwordView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        passwordView.layer.backgroundColor = #colorLiteral(red: 0.9598576427, green: 0.9649086595, blue: 0.9646694064, alpha: 1)
        passwordView.layer.cornerRadius = 6

        loginButton.layer.cornerRadius = 6

        let thickness: CGFloat = 0.3
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.bottomView.frame.size.width, height: thickness)
        topBorder.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        bottomView.layer.addSublayer(topBorder)
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

