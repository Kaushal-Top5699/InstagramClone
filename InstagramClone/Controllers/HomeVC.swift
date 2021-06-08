//
//  HomeVC.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 03/06/21.
//

import UIKit
import Alamofire
import Kingfisher

class HomeVC: UIViewController{
    
    var storyImageArray = [#imageLiteral(resourceName: "avatar1"), #imageLiteral(resourceName: "avatar2"), #imageLiteral(resourceName: "avatar3"), #imageLiteral(resourceName: "avatar4"), #imageLiteral(resourceName: "avatar5"), #imageLiteral(resourceName: "avatar6")]
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    var postArray = [PostModelTwo]()
    let refreshControl = UIRefreshControl()
    
    let cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InstaPostCell", bundle: nil), forCellReuseIdentifier: "InstaPostCell")
        
        storyCollectionView.dataSource = self
        storyCollectionView.register(UINib(nibName: "StoryCell", bundle: nil), forCellWithReuseIdentifier: "StoryCellNib")
        
        //Hides the hairline under navigation bar
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    
        fetchPosts()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewDidLoad()
        self.viewWillAppear(true)
        refreshControl.endRefreshing()
    }
    
    private func fetchPosts() {
        
        let URL = "http://localhost:3000/view-all-posts"
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        if storedToken != nil {
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
            ]
                
                AF.request(URL, method: .get, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { [self] response in

                        if let myBody = response.value as? Array<Dictionary<String, Any>> {
                            self.postArray.removeAll()
                            for body in myBody {
                                
                                let stringURL = body["postImage"] as! String
                                let likes = body["postLikes"] as! Array<Any>
                                let totalLikes = likes.count
                                let post = PostModelTwo(username: body["username"] as! String, caption: body["caption"] as! String, date: body["date"] as! String, postLikes: "\(totalLikes) Likes", image: stringURL)
                                self.postArray.append(post)
                                tableView.reloadData()
                                                                                        
                            }
                            
                        } else if let body = response.value as? Dictionary<String, Any> {
                            
                            self.postArray.removeAll()
                            let imageUrl = body["postImage"] as! String
                            
                            let likes = body["postLikes"] as! Array<Any>
                            let totalLikes = likes.count
                            let post = PostModelTwo(username: body["username"] as! String, caption: body["caption"] as! String, date: body["date"] as! String, postLikes: "\(totalLikes) Likes", image: imageUrl)
                            self.postArray.append(post)
                            tableView.reloadData()
                            
                        }
                    }
        } else {
            print("Authentication required")
        }
    }
    
    private func displayAlert(title: String, message: String, btnTitle: String) {
        
        //Create an alert Box
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //Create an alert button
        let alertButton = UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default) { UIAlertAction in
            //Code for operations after the button is clicked
            print("Button clicked")
            
        }
        //Now connect your alertButton to the alert box and present the alert
        alert.addAction(alertButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}


//MARK: - UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCellNib", for: indexPath) as! StoryCell
        cell.storyImageView.image = storyImageArray[indexPath.row]
        return cell
        
    }
}


//MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = self.postArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstaPostCell", for: indexPath) as! InstaPostCell
        cell.username.text = post.username
        cell.captionLabel.text = post.caption
        cell.dateLabel.text = post.date
        cell.likesLabel.text = String(post.postLikes)
        let url = URL(string: post.image)
        cell.postImageView.kf.setImage(with: url)
        return cell
    }
}
