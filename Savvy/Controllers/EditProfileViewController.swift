//
//  EditProfileViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/21/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import PMAlertController
import SwiftLocation
import CoreLocation
import Kingfisher

class EditProfileViewController: UIViewController {

    @IBOutlet weak var userDescriptionTV: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    var photoHelper = PhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Return image from image picker
        photoHelper.completionHandler = { image in
            self.profileImageView.image = image
            
        }
        
        // MARK : - Round UIImageView
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.profileImageView.clipsToBounds = true
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.layer.shouldRasterize = true
        // will allow you to add a target to an image click
        self.profileImageView.layer.masksToBounds = true
        
        fullnameTextField.text = User.current.fullname
        usernameTextField.text = User.current.username
        userDescriptionTV.text = User.current.userDescription
        locationButton.setTitle(User.current.location, for: UIControlState())
        
        //Hide back button
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Edit Profile"
        //Back button
        let backButton = UIBarButtonItem(image: UIImage(named: "icons8-Back-64"), style: .plain, target: self, action: #selector(GoBack))
        self.navigationItem.leftBarButtonItem = backButton
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        let url = URL(string: User.current.image)
        
        if User.current.image == ""
        {
            profileImageView.image = UIImage(named: "user")
        }
        else
        {
            profileImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func locationButtonPressed(_ sender: UIButton) {
   
            let alertVC = PMAlertController(title: "Locate your current city", description: "Enables access to your location: \n Discover Savvy members near you", image: UIImage(named: ""), style: .alert)
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            
            //TODO: add progress bar
            alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                Location.getLocation(accuracy: .city, frequency: .oneShot, success: { (_, location) -> (Void) in
                    print("Latitide: \(location.coordinate.latitude)")
                    print("Longitude: \(location.coordinate.longitude)")
                    let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    Location.getPlacemark(forLocation: location, success: { placemarks -> (Void) in
                        //print(placemarks)
                        guard let currentCityLoc = placemarks.first?.locality else { return }
                        self.locationButton.setTitle(currentCityLoc, for: UIControlState())
                        // print(placemarks.first?.locality)
                    }, failure: { error -> (Void) in
                        print("Cannot retrive placemark due to an error \(error)")
                    })
                }, error: { (request, last, error) -> (Void) in
                    request.cancel()
                    print("Location monitoring failed due to an error \(error)")
                })
            }))
            
            self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonpressed(_ sender: UIButton) {
        
        guard let fullname = fullnameTextField.text,
              let username = usernameTextField.text,
              let userDescription = userDescriptionTV.text,
              let location = self.locationButton.titleLabel?.text
            else { return }
        
        print(location)
        
        
//        UserService.edit(username: username, bio: bio ) { (user) in
//            guard let user = user else {
//                return
//            }
//            User.setCurrent(user, writeToUserDefaults: true)
//            //SCLAlertView().showSuccess("Success!", subTitle: "Your changes have been saved.")
//            
//        }
        
        UserService.edit(fullname: fullname, username: username, userDescription: userDescription, location: location, profileImage: profileImageView.image ) { (user) in
            guard let user = user else { return }
            
            
            User.setCurrent(user, writeToUserDefaults: true)
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
    //Will allow you to edit user data in firebase
    
    
    // will strictly handle editing the user section in the database

    
    
//    UserService.editProfileImage(url: profilePic, completion: { (user) in
//    if let user = user {
//    User.setCurrent(user, writeToUserDefaults: true)
//    }
//    })
    
    // MARK: - Helper function
    func GoBack(){
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Helper Functions
    func handleTapGesture(gesture: UITapGestureRecognizer) {
        print("handleTapGesture activated")
        photoHelper.presentActionSheet(from: self)
    }
    
    
    
    
}
