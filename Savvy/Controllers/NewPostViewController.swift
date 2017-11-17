//
//  NewPostViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/28/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Kingfisher

class NewPostViewController: UIViewController {
    
    var referenceID = "nil"
    var videoURL : URL?
    static var player : AVPlayer?
    var playerController : AVPlayerViewController?
    var post : Post?
    var cancelButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.gray
        NewPostViewController.player = AVPlayer(url: videoURL!)
        playerController = AVPlayerViewController()
        
        guard NewPostViewController.player != nil && playerController != nil else { return }
        
        playerController!.showsPlaybackControls = false
        playerController?.player = NewPostViewController.player!
        // Add viewcontroller as a child of the current viewcontroller
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        
        //Adding observer to the notification center for continous playback of video
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: NewPostViewController.player!.currentItem)
        
        self.cancelButton = UIButton(frame: CGRect(x: 10.0, y: 20.0, width: 20.0, height: 20.0))
        cancelButton.tag = 100
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        

        // Do any additional setup after loading the view.
        prepareSwipe()
        addElementsToView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NewPostViewController.player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper functions
    
    func prepareSwipe()
    {
        let swipeFromBottom = UISwipeGestureRecognizer(target: self, action: #selector(NewPostViewController.bottomSwiping(_:)))
        swipeFromBottom.direction = .up
        view.addGestureRecognizer(swipeFromBottom)

    }
    
    func bottomSwiping(_ gesture:UIGestureRecognizer)
    {
        if referenceID == "fromPostDetailVC"
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            performSegue(withIdentifier: "toPostDetailVC", sender: self)
        }
    }
    
    func cancel() {
        NewPostViewController.player!.replaceCurrentItem(with: nil)
        //cancelButton.isSelected = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func addElementsToView()
    {
        //Profile image
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.shouldRasterize = true
        // will allow you to add a target to an image click
        imageView.layer.masksToBounds = true
        print(post?.poster.image ?? "")
        if post?.poster.image == ""
        {
            imageView.image = UIImage(named:"user")
        }
        else
        {
            let imageURL = URL(string: (post?.poster.image)!)
            imageView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        //imageView.backgroundColor = UIColor.lightGray
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true

        let usernameButton = UIButton()
        usernameButton.backgroundColor = UIColor.clear
        usernameButton.setTitle(post?.poster.username, for: UIControlState())
        usernameButton.setTitleColor(UIColor.red, for: UIControlState())
        
        //        usernameLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        //        usernameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
//                let followButton = UIButton()
//                followButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//                followButton.backgroundColor = UIColor.clear
//                followButton.setTitle("Follow", for: UIControlState())
        //        followButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        //        followButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let userStackView = UIStackView(arrangedSubviews: [imageView, usernameButton])
        userStackView.axis = UILayoutConstraintAxis.horizontal
        userStackView.distribution = UIStackViewDistribution.fill
        userStackView.alignment = UIStackViewAlignment.center
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        userStackView.spacing = 0
        self.view.addSubview(userStackView)

//                let stackView = UIStackView(arrangedSubviews: [userStackView, followButton])
//                stackView.axis = UILayoutConstraintAxis.horizontal
//                stackView.distribution = UIStackViewDistribution.equalSpacing
//                stackView.alignment = UIStackViewAlignment.center
//                stackView.translatesAutoresizingMaskIntoConstraints = false
//                stackView.spacing = 5
//                self.view.addSubview(stackView)

        //Constraints
        let margins = self.view.layoutMarginsGuide
        userStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor ,constant: 0).isActive = true
        userStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -220).isActive = true
        userStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        //stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

    }

    
    // Allows the video to keep playing on a loop
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if NewPostViewController.player != nil {
            NewPostViewController.player!.seek(to: kCMTimeZero)
            NewPostViewController.player!.play()
        }
    }


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPostDetailVC"
        {
            let vc = segue.destination as! NewPostDetailViewController
            vc.referenceID = "fromPostVC"
            vc.post = post
        }
    }

}
