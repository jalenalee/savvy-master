//
//  VideoViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 7/31/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //URL of video to save to Firebase storage. URL is being passed from CameraViewController
    private var videoURL: URL
    
    // Allows you to play the actual mp4 or video
    var player: AVPlayer?
    // Allows you to display the video content of a AVPlayer
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        //Setting the video url of the AVPlayer
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        // Setting AVPlayer to the player property of AVPlayerViewController
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        // Added an observer for when the video stops playing so it can be on a continuous loop
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        // Adding buttons programatically
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 20.0, height: 20.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        //TODO: Need to fix frame of x and y
        let nextButton = UIButton(frame: CGRect(x: 320, y: 680, width: 60, height: 30))
        nextButton.backgroundColor = UIColor.clear
        nextButton.setTitle("Done", for: UIControlState())
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        view.addSubview(nextButton)
        
        //Constraints 
//        let margins = self.view.layoutMarginsGuide
//        nextButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20).isActive = true
//        nextButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    func cancel() {
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Takes you to AddPostViewController
    func nextPressed()
    {
        print("Next Button pressed")

        // Setting nil to the player so video will stop playing
        player!.replaceCurrentItem(with: nil)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Post", bundle: nil)
        let addPostViewController = storyboard.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        // Passing the videoURL so I can store it in Firebase storage
        addPostViewController.videoURL = videoURL
        //self.present(addPostViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(addPostViewController, animated: true)
 
    }
    
    // Allows the video to keep playing on a loop
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}
