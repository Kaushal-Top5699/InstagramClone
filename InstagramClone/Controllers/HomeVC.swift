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
    var postArray = [PostModel]()
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
    
        fetchPosts(clear: false)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        Reload.fetchPostsCallback = fetchPosts
        Reload.timestamp = 0
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        fetchPosts(clear: false)
        refreshControl.endRefreshing()

    }
    
    private func fetchPosts(clear: Bool) {
        
        if clear {
            postArray.removeAll()
        }
        
        print("Fetch called again")
        print(Reload.timestamp)
        
        let URL = "http://localhost:3000/view-all-posts"
        let URL2 = "http://localhost:3000/get-post"
        let storedToken = UserDefaults.standard.object(forKey: "token")
        
        
        let limit = 2
        
        if storedToken != nil {
            let headers: HTTPHeaders = [
                "Authorization": storedToken as! String,
                "Content-Type": "application/json"
            ]
                
            let urlOfViewPost = "\(URL)?limit=\(limit)&timestamp=\(Reload.timestamp)"
            
                AF.request(urlOfViewPost, method: .get, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { [self] response in

                        if let body = response.value as? Dictionary<String, Any> {
                            
                            let myBody = body["posts"] as! Array<Any>
                            
                            if let lastItem = body["timestamp"] as? CLong {
                                
                                if lastItem >= 0 {
                                    Reload.timestamp = lastItem
                                    print(Reload.timestamp)
                                }
                            }
                            
                            for uid in myBody {
                        
                                let post2 = PostModel(username: "", caption: "", date: "", postLikes: "", image: "")
                                postArray.append(post2)
                                
                                let urlOfGetPost = "\(URL2)?id=\(uid)"
                                AF.request(urlOfGetPost, method: .get, encoding: JSONEncoding.default, headers: headers)
                                    .responseJSON { response in
                                        
                                        if let myPost = response.value as? Dictionary<String, Any> {
                                           
                                            let likes = myPost["postLikes"] as! Array<Any>
                                            let totalLikes = likes.count
                                            let username = myPost["username"] as! String
                                            let caption = myPost["caption"] as! String
                                            let date = myPost["date"] as! String
                                            let image = myPost["postImage"] as! String
                                            
                                            post2.username = username
                                            post2.caption = caption
                                            post2.date = date
                                            post2.postLikes = String(totalLikes)
                                            post2.image = image

                                            tableView.reloadData()
                                            
                                        }
                                        
                                    }
                            }
                            
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
