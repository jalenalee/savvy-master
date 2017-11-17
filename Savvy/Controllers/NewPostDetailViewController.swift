//
//  NewPostDetailViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/28/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import Firebase

class NewPostDetailViewController: UIViewController {
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDetailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var hireButton: UIButton!
    var post : Post?
    
    var referenceID = "nil"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareSwips()
        setupUserInteraction()
        usernameButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = true
        
        let username = post?.poster.username
        let postDescription = post?.postDescription
        // Capitializing Title when recieving from Firebase
        let postTitle = post?.title.capitalized
        usernameButton.setTitle(username, for: UIControlState())
        postTitleLabel.text = postTitle
        postTitleLabel.numberOfLines = 0
        postTitleLabel.sizeToFit()
        postDetailLabel.text = postDescription
        postDetailLabel.numberOfLines = 0;
        postDetailLabel.sizeToFit()
    }
    
    @IBAction func hireButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Hire", bundle: nil)
        let hireVC = storyboard.instantiateViewController(withIdentifier: "HireViewController") as! HireViewController
        hireVC.postUser = post?.poster
        NewPostViewController.player?.replaceCurrentItem(with: nil)
        self.present(hireVC, animated: false, completion: nil)
    }
    
    @IBAction func usernameButtonPressed(_ sender: UIButton) {
    }
    
    func prepareSwips()
    {
        
        let swipefromBottom = UISwipeGestureRecognizer(target: self, action: #selector(NewPostDetailViewController.downSwiping(_:)))
        swipefromBottom.direction = .down
        view.addGestureRecognizer(swipefromBottom)
        
        
    }
    
    
    fileprivate func setupUserInteraction()
    {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else{
            return
        }
        guard let uid = post?.poster.uid else{
            return
        }
        
        
        if currentLoggedInUser == uid {
            DispatchQueue.main.async {
                self.hireButton.isHidden = true
            }
        } else{
            DispatchQueue.main.async {
                self.hireButton.isHidden = false
            }
        }
    }


    
    
    func downSwiping(_ gesture:UIGestureRecognizer)
    {
        if referenceID == "fromPostVC"
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            performSegue(withIdentifier: "toPostVC", sender: self)
        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toPostVC"
        {
        let vc =  segue.destination as! NewPostViewController
        vc.referenceID = "fromPostDetailVC"
        }
    }
    

}
