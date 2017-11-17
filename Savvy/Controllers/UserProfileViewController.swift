//
//  UserProfileViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/25/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import AVFoundation
import AVKit
import TwicketSegmentedControl

class UserProfileViewController : UIViewController, TwicketSegmentedControlDelegate {
    
    static var post : Post?
    var postVC = PostRootViewController()
//    let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
//    var userProfileViewController : UserProfileViewController?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user : User?
    var posts = [Post]()
    var jobs = [Job]()
    var reciepts = [Reciept]()
    var profileHandle: DatabaseHandle = 0
    var profileRef: DatabaseReference?
//    var authHandle: AuthStateDidChangeListenerHandle?
    var selectedIndex = 0
    
    /*
     @IBAction func logoutButtonPressed(_ sender: Any) {
     AuthService.presentLogOut(viewController: self)
     }
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.userProfileViewController = profileStoryboard.instantiateViewController(withIdentifier: "profileStoryboard") as? UserProfileViewController
        
       // authHandle = AuthService.authListener(viewController: self)
        guard let postUser = self.user else { return }
        
        let user = postUser
        navigationItem.title = user.username
        
        profileHandle = UserService.observeProfile(for: user) { [unowned self](ref, user, posts, allJobs, allReciepts) in
            self.profileRef = ref
            self.user = user
            self.posts = posts
            self.jobs = allJobs
            self.reciepts = allReciepts
            
            print(self.jobs)
            print(self.reciepts)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
//        // Adding Bar button item programatically
//        let rightButtonItem = UIBarButtonItem.init(
//            title: "Menu",
//            style: .done,
//            target: self,
//            action: #selector(settingsPressed)
//        )
//        rightButtonItem.tintColor = UIColor(red: 255.0/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
//        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // retrieve the corresponding data from Firebase with our profile service method
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
//    deinit {
//        AuthService.removeAuthListener(authHandle: authHandle)
//        
//        // adding the following in deinit to remove the observer when the view controller is dismissed.
//        profileRef?.removeObserver(withHandle: profileHandle)
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Helper Functions
//    func settingsPressed()
//    {
//        AuthService.presentLogOut(viewController: self)
//    }
    
//    func toEditProfile()
//    {
//        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
//        let editProfileVC = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//        self.navigationController?.pushViewController(editProfileVC, animated: true)
//    }
//    
    
    // MARK: - TwicketSegmentedControl Delegate
    
    func didSelect(_ segmentIndex: Int)
    {
        
        switch segmentIndex {
        case 0:
            selectedIndex = segmentIndex
            collectionView.reloadData()
            break
        case 1:
            selectedIndex = segmentIndex
            collectionView.reloadData()
            break
        case 2:
            selectedIndex = segmentIndex
            collectionView.reloadData()
            break
        default:
            break
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension UserProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //TODO: Need to retun self.posts.count
        var items = Int()
        switch selectedIndex {
        case 0:
            items = self.posts.count
            break
        case 1:
            items = self.jobs.count
            break
        case 2:
            items = self.reciepts.count
        default:
            break
        }
        return items
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        let jobCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileJobCell", for: indexPath) as! ProfileJobCell
        
        switch selectedIndex {
        case 0:
            let post = posts[indexPath.row]
            let imageURL = URL(string: post.imageSnapURL)
            profileCell.imageView.kf.setImage(with: imageURL)
            return profileCell
        case 1:
            let job = jobs[indexPath.row]
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.short
            dateformatter.timeStyle = DateFormatter.Style.short
            let now = dateformatter.string(from: job.creationDate)
            
            jobCell.titleLabel.text = job.title
            jobCell.usernameLabel.text = job.sender.username
            jobCell.descriptionLabel.text = job.jobDescription
            jobCell.date.text = now
            return jobCell
        case 2:
            //TODO: Need to change to reciept
            let reciept = reciepts[indexPath.row]
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.short
            dateformatter.timeStyle = DateFormatter.Style.short
            let now = dateformatter.string(from: reciept.creationDate)
            
            jobCell.titleLabel.text = reciept.title
            jobCell.usernameLabel.text = reciept.assignedJobUser.username
            jobCell.descriptionLabel.text = reciept.jobDescription
            jobCell.date.text = now
            
            return jobCell
        default:
            return profileCell
        }
        
        //return cell
        
    }
    
    // If collectionView has a header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        let imageURL = URL(string:(user?.image)!)
        
        guard kind == UICollectionElementKindSectionHeader else { fatalError("Unexpected element kind")}
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
        
        headerView.fullNameLabel.text = self.user?.fullname
        
        // If User image is empty use placeholder image
        if User.current.image != ""
        {
            // MARK : - Round UIImageView
            headerView.profileImageView.layer.borderColor = UIColor.black.cgColor
            headerView.profileImageView.clipsToBounds = true
            headerView.profileImageView.translatesAutoresizingMaskIntoConstraints = false
            headerView.profileImageView.layer.cornerRadius = headerView.profileImageView.frame.size.width/2
            headerView.profileImageView.contentMode = .scaleAspectFill
            headerView.profileImageView.isUserInteractionEnabled = true
            headerView.profileImageView.layer.shouldRasterize = true
            // will allow you to add a target to an image click
            headerView.profileImageView.layer.masksToBounds = true
            headerView.profileImageView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        else
        {
            
            headerView.profileImageView.image = UIImage(named: "user")
        }
        
        headerView.bioTextView.text = self.user?.userDescription
        headerView.locationLabel.text = self.user?.location
//        headerView.editProfileButton.addTarget(self, action: #selector(toEditProfile), for: .touchUpInside)
        headerView.segmentedControl.delegate = self
        headerView.user = self.user
        self.selectedIndex = headerView.segmentedControl.selectedSegmentIndex
        return headerView
        
        // TODO: Need to implement
        //        let postCount = user.postCount ?? 0
        //        headerView.postCountLabel.text = "\(postCount)"
        //
        //        let followerCount = user.followerCount ?? 0
        //        headerView.followerCountLabel.text = "\(followerCount)"
        //
        //        let followingCount = user.followingCount ?? 0
        //        headerView.followingCountLabel.text = "\(followingCount)"
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch selectedIndex {
        case 0:
            let post = posts[indexPath.row]
            // Setting post global variable to get the current post being selected
            //ProfileViewController.post = post
            //self.postVC = PostRootViewController()
            postVC.post = post
            self.navigationController?.pushViewController(postVC, animated: true)
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
        
        
    }
}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout
{
    //we use the number of columns to calculate the item size of each UICollectionViewCell. This guarentees we'll have a evenly sized 3x3 row regardless of the device we're using.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize = CGSize()
        
        
        switch selectedIndex
        {
        case 0:
            let columns: CGFloat = 2
            let spacing: CGFloat = 1.5
            let totalHorizontalSpacing = (columns - 1) * spacing
            let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
            let itemHeight = (collectionView.bounds.width - totalHorizontalSpacing) / columns + 33
            let newItemSize = CGSize(width: itemWidth, height: itemHeight)
            itemSize = newItemSize
            break
        case 1:
            itemSize = CGSize(width: view.frame.width, height: 200)
            break
        case 2:
            itemSize = CGSize(width: view.frame.width, height: 200)
            break
        default:
            break
        }
        
        return itemSize
        
    }
    
    
    //        let columns: CGFloat = 2
    //        let spacing: CGFloat = 2
    //        let totalHorizontalSpacing = (columns - 1) * spacing
    //
    //        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
    //        let itemHeight = (collectionView.bounds.width - totalHorizontalSpacing) / columns + 33
    //        let itemSize = CGSize(width: itemWidth, height: itemHeight)
    //        return itemSize
    
    //Set the size for collection view dependent on segmented control
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        return CGSize(width: view.frame.width, height: 50)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}

