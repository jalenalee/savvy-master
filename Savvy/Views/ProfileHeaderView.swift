//
//  ProfileHeaderView.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/7/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import Firebase

class ProfileHeaderView: UICollectionReusableView {
    
    var user : User? {
        didSet{
            setupUserInteraction()
        }
    }
    
    // MARK: - Subviews
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var segmentedControl: TwicketSegmentedControl!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    // MARK: - Lifecyclex
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bioTextView.isEditable = false
        let segmentedControlTitles = ["Posts", "Jobs", "Reciepts"]
        segmentedControl.setSegmentItems(segmentedControlTitles)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.sliderBackgroundColor = UIColor(red: 255.0/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    }
    
    // MARK: - IBACTION
    
    fileprivate func setupUserInteraction (){
        
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else{
            return
        }
        guard let uid = user?.uid else{
            return
        }
        
        if currentLoggedInUser == uid {
            editProfileButton.isHidden = false
            settingsButton.isHidden = false
        } else{
            print("Not current user")
        }
    }

    
    
}
