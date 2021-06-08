//
//  CreatePostVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 04/06/21.
//

import UIKit
import Firebase
import Alamofire

class CreatePostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    
    let tagAndPlaceArray = ["Tag Friend", "Add Place"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageView.image = #imageLiteral(resourceName: "addIcon")
        captionText.text = "Write a caption..."
    }

    @IBAction func shareBtn(_ sender: UIBarButtonItem) {
        progressView.isHidden = false
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "postData/\(randomID).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        let taskRef = uploadRef.putData(imageData, metadata: uploadMetaData) { downloadMetaData, error in
            if error != nil {
                print("ERROR")
                return
            }
            uploadRef.downloadURL { url, error in
                if error != nil {
                    print("Couldn't get image URL")
                    return
                }
                let urlString = String(describing: url!)
                //print("Image URL::: \(urlString)")
                
                let storedToken = UserDefaults.standard.object(forKey: "token")
                let URL = "http://localhost:3000/new-post"
                
                let parameters: [String: String] = [
                    "postImage": urlString,
                    "caption": self.captionText.text!,
                ]
                let headers: HTTPHeaders = [
                    "Authorization": storedToken as! String,
                    "Content-Type": "application/json"
                ]
                
                AF.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        
                        let statusCode: Int = response.response!.statusCode
                        if statusCode == 201 {
                            print("Post uploaded, status code \(statusCode)")
                            self.captionText.text = "Write a caption..."
                            self.imageView.image = #imageLiteral(resourceName: "addIcon")
                            self.progressView.isHidden = true
                            
                            Reload.timestamp = 0
                            Reload.fetchPostsCallback!(true)
                            
                        } else {
                            print(statusCode)
                            return
                        }
                        
                    }
            }
            print("SUCCESS")
        }
        taskRef.observe(.progress) { [weak self] snapshot in
            guard let pctThere = snapshot.progress?.fractionCompleted else { return }
            print("You are \(pctThere) complete")
            self?.progressView.progress = Float(pctThere)
        }
    }
    
    @objc func imageClicked() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension CreatePostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagAndPlaceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.tagAndPlaceArray[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = data
        return cell
        
    }
}
