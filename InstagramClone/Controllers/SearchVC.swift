//
//  SearchVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 07/06/21.
//

import UIKit
import Alamofire

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
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        if storedToken != nil {
            
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
            ]
            
            var image = UIImage()
            AF.request(URL, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { [self] response in
                    
                    if let myBody = response.value as? Array<Dictionary<String, Any>> {
                        for body in myBody {
                            image = downloadImage(urlString: body["postImage"] as! String)!
                            self.imageArray.append(ImageModel(image: image))
                            //print("Array Appended")
                        }
                    } else if let body = response.value as? Dictionary<String, Any> {
                        image = downloadImage(urlString: body["postImage"] as! String)!
                        self.imageArray.append(ImageModel(image: image))
                        //print("Array Appended")
                    }
                    self.collectionView.reloadData()
                    print("collectionView Reloaded")
                }
        } else {
            print("Authentication Required")
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

//MARK: - UICollectionViewDataSource
extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postImage = self.imageArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = postImage.image
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

