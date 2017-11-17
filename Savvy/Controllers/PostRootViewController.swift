//
//  PostRootViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/10/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import ISHPullUp
import Firebase

class PostRootViewController: ISHPullUpViewController {
    
    var post : Post?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
//    fileprivate func setupUserInteraction (){
//        
//        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else{
//            return
//        }
//        guard let uid = post?.poster.uid else{
//            return
//        }
//        
//        
//        if currentLoggedInUser == uid {
//            hireButton.isHidden = false
//        } else{
//            hireButton.isHidden = true
//        }
//    }

    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
    

    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        
//        let newVideoURL = URL(string: (ProfileViewController.post?.videoURL)!)
//        self.videoURL = newVideoURL
//        commonInit()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
       // super.viewWillAppear(animated)
      //  let newVideoURL = URL(string: (ProfileViewController.post?.videoURL)!)
        //self.videoURL = newVideoURL
        //commonInit()
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //  super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func commonInit()
    {
//        videoURL = URL(string: "hello")
        let storyBoard = UIStoryboard(name: "Post", bundle: nil)
        let videoURL = URL(string:(post?.videoURL)!)
        guard videoURL != nil else { return }
        let contentVC = PostViewController(videoURL: videoURL!)
        print(videoURL ?? "String")
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        bottomVC.post = self.post
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomLayoutMode = .shift
        bottomVC.pullUpController = self
        contentDelegate = contentVC
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
    }

    override func viewDidLoad() {
        //super.viewDidLoad()
        commonInit()

        // Do any additional setup after loading the view.
    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
