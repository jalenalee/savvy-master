//
//  ExploreViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/14/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import Kingfisher

class ExploreViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var exploreCollectionView: UICollectionView!
    var filteredPosts = [Post]()
    var postsArray = [Post]()
    
    var filteredUsers = [User]()
    var usersArray = [User]()
    
    let headerID = "headerID"
    var scopeIndex : Int = 0
    
    let postRootVC = PostRootViewController()
    
    // Instantiating search bar lazily
    // UI search bar that will allow you to type in text and filter out results
    //must set delegate to self to get control over certain aspects of search bar
//    lazy var searchBar : UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.showsScopeBar = true
//        searchBar.scopeButtonTitles = ["Hello", "Hi"]
//        searchBar.placeholder = "Search for Posts or Users"
//        searchBar.barTintColor = .gray
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
//        searchBar.delegate = self
//        return searchBar
//        } ()
//    
//    var textFIeld : UITextField
//    {
//        let newtextField = UITextField()
//        newtextField.delegate = self
//        return newtextField
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.searchBar.sizeToFit()
        exploreCollectionView.backgroundColor = UIColor.clear
        //navigationController?.navigationBar.addSubview(searchBar)
        
        self.navigationController?.navigationBar.isHidden = true

        
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        
//        let height: CGFloat = 50 //whatever height you want
//        let bounds = self.navigationController!.navigationBar.bounds
        //self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
        // Setting the constraints of the navigation bar
        //let navBar = navigationController?.navigationBar
        //navBar?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        //TODO: Nneed to implement constraints
//        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        // Do any additional setup after loading the view.
        
        exploreCollectionView?.alwaysBounceVertical = true
        exploreCollectionView?.keyboardDismissMode = .onDrag
        //fetchPosts()
       // fetchPosts(child: "title", value: "men")
        
        exploreCollectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // searchBar.isHidden = false
        filteredPosts.removeAll()
       // searchBar.text = ""
        self.exploreCollectionView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func viewDidLayoutSubviews() {
//        searchBar.sizeToFit()
//    }

}

extension ExploreViewController : UISearchBarDelegate
{
    // this function will detect change in the search bar and filter out the results returned based off what is entered in the search bar
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // this is assigning your array of events to an initially empty filtered array that is created based off the results that are typed in to the keyboard
//        
//        filteredPosts = self.postsArray.filter { (post) -> Bool in
//            return post.title.lowercased().contains(searchText.lowercased())
//            
//        }
//
//        // here to continously reload collection view with the proper data
//        self.exploreCollectionView?.reloadData()
//    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         guard let text = searchBar.text else { return }
        
        let lowercasedText = text.lowercased()
        if scopeIndex == 0
        {
            fetchPosts(stringValue: lowercasedText)
        }
        else if scopeIndex == 1
        {
            fetchUsers(stringValue: lowercasedText)
        }
      
    }
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Resigns first responder of search bar
        searchBar.resignFirstResponder()
    }
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
     {
        if searchBar.text?.isEmpty == true
        {
            filteredPosts.removeAll()
            self.exploreCollectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterSearchController(searchBar)
        switch selectedScope {
        case 0:
            searchBar.text = ""
            self.scopeIndex = selectedScope
            self.filteredPosts.removeAll()
            self.exploreCollectionView.reloadData()
            break
        case 1:
            searchBar.text = ""
            self.scopeIndex = selectedScope
            self.filteredUsers.removeAll()
            self.exploreCollectionView.reloadData()
            break
        default:
            break
        }
    }

}

extension ExploreViewController : UICollectionViewDataSource
{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //make sure that the screen is loaded with the proper number of cells when you first go to the screen
        switch scopeIndex {
        case 0:
            return filteredPosts.count
        case 1:
            return filteredUsers.count
        default:
            return 0
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        searchBar.isHidden = true
//        searchBar.resignFirstResponder()
        switch scopeIndex {
        case 0:
            let post = filteredPosts[indexPath.item]
           // let postRootVC = PostRootViewController()
//          self.postRootVC.post = post
            let storyboard = UIStoryboard.init(name: "Post", bundle: nil)
            let postVC = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
            let url = URL(string: post.videoURL)
            postVC.videoURL = url
            postVC.post = post
            navigationController?.pushViewController(postVC, animated: true)
            break
        case 1:
            let user = filteredUsers[indexPath.item]
            print(user.username)
            let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            profileVC.user = user
            navigationController?.pushViewController(profileVC, animated: true)
            
            break
        default:
            break
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //creates a cell and cast it as the Appropriate type
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostSearchCell", for: indexPath) as! PostCell
        let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell
        
        switch scopeIndex {
        case 0:
            let post = filteredPosts[indexPath.item]
            let imageURL = URL(string: post.imageSnapURL)
            DispatchQueue.main.async {
                postCell.imageView.kf.setImage(with: imageURL)
            }
            postCell.titleLabel.text = post.title.capitalized
            return postCell
        case 1:
            let user = filteredUsers[indexPath.item]
            userCell.usernameLabel.text = user.username
            userCell.usedDescription.text = user.userDescription
            if user.image != ""
            {
                let imageURL = URL(string: user.image)
                userCell.profileImageView.kf.setImage(with: imageURL)
            }
            else
            {
                userCell.profileImageView.image = UIImage(named: "user")
            }
            return userCell
        default:
            return postCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! SearchHeaderView
        header.searchBar.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

}

extension ExploreViewController : UICollectionViewDelegateFlowLayout
{
    //we use the number of columns to calculate the item size of each UICollectionViewCell. This guarentees we'll have a evenly sized 3x3 row regardless of the device we're using.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch scopeIndex {
        case 0:
            let columns: CGFloat = 3
            let spacing: CGFloat = 1.5
            let totalHorizontalSpacing = (columns - 1) * spacing
            
            let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
            let itemHeight = (collectionView.bounds.width - totalHorizontalSpacing) / columns + 33
            let itemSize = CGSize(width: itemWidth, height: itemHeight)
            return itemSize
        case 1:
            let itemSize = CGSize(width: view.frame.width, height: 200)
            return itemSize
        default:
            return CGSize(width: view.frame.width, height: 200)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }

}



extension ExploreViewController
{
    
    // TODO: Need to implement search query using firebase. I don't to load the whole array which could have way over 1,000 elements
    fileprivate func fetchPosts(stringValue: String){
        
        //create a reference to the location in the database that you want to pull from and observe the value there
        let ref = Database.database().reference().child("posts")
        // this will retur a snapshot with all the data at that location in the database and cast the results as a dictionary for later use

        
        // Originally how it worked
        //ref.observe(.value, with: { (snapshot) in
        //print(snapshot)
        //let query = ref.queryOrdered(byChild: "posts/title").queryEqual(toValue:value)
//        print(query)
        
//        let startString = "Made"
        
//        ref.queryOrdered(byChild: "title").queryEqual(toValue:stringValue)
//            .queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
        
        let endString = stringValue + "\\uf8ff"
        ref.queryOrdered(byChild: "title").queryStarting(atValue: stringValue).queryEnding(atValue: endString).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            
            guard let dictionaries = snapshot.value as? [String: Any] else{
                return print(snapshot.value ?? "nil")
            }
            
            print(dictionaries)
            //does the job of sorting dictionary elements by key and value
            //displaying the key and each corresponding value
            dictionaries.forEach({ (key,value) in
                // print(key, value)
                //creating an eventDictionary to store the results of previous call
                
                guard let postDictionary = value as? [String: Any] else{
                    return
                }
                
                //                userDictionaries.forEach({ (key, value) in
                //                    
                //                    guard let postDictionary = value as? [String: Any] else{
                //                        return
                //                    }
                
                //print(postDictionary)
                //will cast each of the values as an Event based off my included struct
                //Make sure to create a model it is the only way to have the data in the format you want for easy access
                
                print(key)
                let newPost = Post(key: key, postDictionary:postDictionary)
                
                
                //Filtering for duplicates in array
                let filteredArr = self.postsArray.filter { (post) -> Bool in
                    print(post.key ?? "nil")
                    return post.key == newPost?.key
                }
                
                
                print(newPost?.key ?? "nil")
                
                //If arrat equals 0 append newPost
                if filteredArr.count == 0 {
                    //append
                    self.postsArray.append(newPost!)
                }
                
                
                
                self.filteredPosts = self.postsArray.filter { (post) -> Bool in
                    return post.title.lowercased().contains(stringValue.lowercased())
                }
                
                DispatchQueue.main.async {
                    self.exploreCollectionView?.reloadData()
                }
                
                // appends that to the dictionary to create the dictionary of events
                
                //                if self.postsArray.count == 0
                //                {
                //                    self.postsArray.append(newPost!)
                //
                //                    
                //                    self.filteredPosts = self.postsArray.filter { (post) -> Bool in
                //                        return post.title.lowercased().contains(stringValue.lowercased())
                //                        
                //                    }
                //                    DispatchQueue.main.async {
                //                        self.exploreCollectionView?.reloadData()
                //                    }
                //
                //                }
                //                else
                //                {
                //                    
                //                    for post in self.postsArray
                //                    {
                //                        
                //                        if post.key == newPost?.key
                //                        {
                //                            
                //                            self.filteredPosts = self.postsArray.filter { (post) -> Bool in
                //                                return post.title.lowercased().contains(stringValue.lowercased())
                //                                
                //                            }
                //                            DispatchQueue.main.async {
                //                                self.exploreCollectionView?.reloadData()
                //                            }
                //                            break
                //                        }
                //                        
                //                        if post.key != newPost?.key
                //                        {
                //                            
                //                            self.postsArray.append(newPost!)
                //                            //                            self.postsArray.sort(by: { (post1, post2) -> Bool in
                //                            //                                return post1.title.compare(post2.title) == .orderedAscending
                //                            //                            })
                //                            
                //                            self.filteredPosts = self.postsArray.filter { (post) -> Bool in
                //                                return post.title.lowercased().contains(stringValue.lowercased())
                //                                
                //                            }
                //                            DispatchQueue.main.async {
                //                                self.exploreCollectionView?.reloadData()
                //                            }
                //                                
                //                            }
                //
                //                        }
                //                    }
            })
            
            print(self.postsArray)
            // will sort the array elements based off the name
            
            
            print(self.postsArray)
            // will again reload the data
            
        }) { (err) in
            print("Failed to fetch posts for search")
        }
    }
    
    // TODO: Need to implement search query using firebase. I don't to load the whole array which could have way over 1,000 elements
    fileprivate func fetchUsers(stringValue: String){
        
        //create a reference to the location in the database that you want to pull from and observe the value there
        let ref = Database.database().reference().child("users")
        // this will retur a snapshot with all the data at that location in the database and cast the results as a dictionary for later use
        
        
        // Originally how it worked
        //ref.observe(.value, with: { (snapshot) in
        //print(snapshot)
        //let query = ref.queryOrdered(byChild: "posts/title").queryEqual(toValue:value)
        //        print(query)
        
        //        let startString = "Made"
        
        //        ref.queryOrdered(byChild: "title").queryEqual(toValue:stringValue)
        //            .queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
        
        let endString = stringValue + "\\uf8ff"
        ref.queryOrdered(byChild: "username").queryStarting(atValue: stringValue).queryEnding(atValue: endString).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            
            guard let dictionaries = snapshot.value as? [String: Any] else{
                return print(snapshot.value ?? "nil")
            }
            
            print(dictionaries)
            //does the job of sorting dictionary elements by key and value
            //displaying the key and each corresponding value
            dictionaries.forEach({ (key,value) in
                // print(key, value)
                //creating an eventDictionary to store the results of previous call
                
                guard let userDictionary = value as? [String: Any] else{
                    return
                }
                
                //                userDictionaries.forEach({ (key, value) in
                //
                //                    guard let postDictionary = value as? [String: Any] else{
                //                        return
                //                    }
                
                //print(postDictionary)
                //will cast each of the values as an Event based off my included struct
                //Make sure to create a model it is the only way to have the data in the format you want for easy access
                
                print(key)
                let newUser = User(key: key, userDictionary: userDictionary)
                
                //guard let newUser != nil { return nil }
                
                //Filtering for duplicates in array
                let filteredArr = self.usersArray.filter { (user) -> Bool in
                    print(user.uid)
                    return user.uid == newUser?.uid
                }
                
                
                print(newUser?.uid ?? "nil")
                
                //If arrat equals 0 append newPost
                if filteredArr.count == 0 {
                    //append
                    self.usersArray.append(newUser!)
                }
                
                
                
                self.filteredUsers = self.usersArray.filter { (user) -> Bool in
                    return user.username.lowercased().contains(stringValue.lowercased())
                }
                
                DispatchQueue.main.async {
                    self.exploreCollectionView?.reloadData()
                }
                
            })
            
            print(self.usersArray)
            // will sort the array elements based off the name
            
            
            print(self.usersArray)
            // will again reload the data
            
        }) { (err) in
            print("Failed to fetch posts for search")
        }
    }
    
    
    
}
