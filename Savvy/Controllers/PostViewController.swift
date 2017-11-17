//
//  PostViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/8/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PostViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var videoURL : URL?
    static var player : AVPlayer?
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        PostViewController.player = AVPlayer(url: videoURL!)
        playerController = AVPlayerViewController()
        
        guard PostViewController.player != nil && playerController != nil else { return }
        
        playerController!.showsPlaybackControls = false
        playerController?.player = PostViewController.player!
        // Add viewcontroller as a child of the current viewcontroller
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        
        //Adding observer to the notification center for continous playback of video
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: PostViewController.player!.currentItem)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 20.0, height: 20.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)

        //Adding UIPanGestureRecognizer
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//        self.view.addGestureRecognizer(gestureRecognizer)
        

        // Do any additional setup after loading the view.
        //self.addingElementsToView()
    }
    
    
    // Allows tab bar to appear and dissapear
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = true
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PostViewController.player?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancel() {
        PostViewController.player!.replaceCurrentItem(with: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Allows the video to keep playing on a loop
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if PostViewController.player != nil {
            PostViewController.player!.seek(to: kCMTimeZero)
            PostViewController.player!.play()
        }
    }
    
//    func addingElementsToView()
//    {
//        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 20.0, height: 20.0))
//        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
//        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//        self.view.addSubview(cancelButton)
//        
//        //Profile image
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.lightGray
//        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        let usernameButton = UIButton()
//        usernameButton.backgroundColor = UIColor.clear
//        usernameButton.setTitle(User.current.username, for: UIControlState())
//        usernameButton.setTitleColor(UIColor.red, for: UIControlState())
//        
////        usernameLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
////        usernameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//        
//        let followButton = UIButton()
//        followButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//        followButton.backgroundColor = UIColor.clear
//        followButton.setTitle("Follow", for: UIControlState())
////        followButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
////        followButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        
//        let userStackView = UIStackView(arrangedSubviews: [imageView, usernameButton])
//        userStackView.axis = UILayoutConstraintAxis.horizontal
//        userStackView.distribution = UIStackViewDistribution.equalSpacing
//        userStackView.alignment = UIStackViewAlignment.center
//        userStackView.translatesAutoresizingMaskIntoConstraints = false
//        userStackView.spacing = 7
//        
//        let stackView = UIStackView(arrangedSubviews: [userStackView, followButton])
//        stackView.axis = UILayoutConstraintAxis.horizontal
//        stackView.distribution = UIStackViewDistribution.equalSpacing
//        stackView.alignment = UIStackViewAlignment.center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.spacing = 5
//        self.view.addSubview(stackView)
//        
//        //Constraints
//        let margins = self.view.layoutMarginsGuide
//        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor ,constant: 0).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
//        //stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        //stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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

extension PostViewController : ISHPullUpContentDelegate
{
    func pullUpViewController(_ vc: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forContentViewController _: UIViewController) {
        // update edgeInsets
        self.view.layoutMargins = edgeInsets
        
        // call layoutIfNeeded right away to participate in animations
        // this method may be called from within animation blocks
        self.view.layoutIfNeeded()
    }
}
