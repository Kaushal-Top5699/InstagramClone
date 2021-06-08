//
//  SearchVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 07/06/21.
//

import UIKit
import Alamofire
import Kingfisher

class SearchVC: UIViewController {
    
    @IBOutlet weak var serachBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [ImageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        setupUI()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        fetchImageCollection()
        
    }

    @objc func searchClicked() {
        performSegue(withIdentifier: "toAllUsersVC", sender: self)
    }
    
    private func setupUI() {
        serachBar.layer.borderWidth = 0.3
        serachBar.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        serachBar.layer.backgroundColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)
        serachBar.layer.cornerRadius = 6

        serachBar.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchClicked))
        serachBar.addGestureRecognizer(gestureRecognizer)
    }
    
    private func fetchImageCollection() {
        
        let URL = "http://localhost:3000/view-all-posts"
        let URL2 = "http://localhost:3000/get-post"
        
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        if storedToken != nil {
            
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
            ]
            
            
            AF.request(URL, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { [self] response in
                    
                    if let myBody = response.value as? Array<Any> {
                        
                        for postUid in myBody {
                            
                            let newUrl = "\(URL2)?id=\(postUid)"
                            AF.request(newUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                                .responseJSON { response in
                                    
                                    if let myPost = response.value as? Dictionary<String, Any> {
                                        
                                        let imageUrl = myPost["postImage"] as! String
                                        let myImage = ImageModel(image: imageUrl)
                                        imageArray.append(myImage)
                                        collectionView.reloadData()
                                    }
                                }
                        }
                    }
                }
            
        } else {
            print("Authentication Required")
        }
    }
}

//MARK: - UICollectionViewDataSource
extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postImage = self.imageArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let url = URL(string: postImage.image)
        cell.imageView.kf.setImage(with: url)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout for setting 3 per row
extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
}

