//
//  CreateUserSecondVC.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/25/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import PMAlertController
import SwiftLocation
import CoreLocation

class CreateUserSecondVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    let photoHelper = PhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Will implement in 1.1
        self.locationButton.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGesture)
        
        
        //Completion handler whcih returns an image
        photoHelper.completionHandler = { image in
            
            // MARK : - Round UIImageView
            self.profileImage.layer.borderColor = UIColor.black.cgColor
            self.profileImage.clipsToBounds = true
            self.profileImage.translatesAutoresizingMaskIntoConstraints = false
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            self.profileImage.contentMode = .scaleAspectFill
            self.profileImage.isUserInteractionEnabled = true
            self.profileImage.layer.shouldRasterize = true
            // will allow you to add a target to an image click
            self.profileImage.layer.masksToBounds = true
            self.profileImage.image = image
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentCityLocation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        let userLocation = locationButton.titleLabel?.text
        
        // TODO: Need update function
        UserService.edit(fullname: User.current.fullname, username: User.current.username, userDescription: User.current.userDescription, location: userLocation, profileImage: profileImage.image) { (user) in
            guard let user = user else { return }
            User.setCurrent(user, writeToUserDefaults: true)
        }
        
        let initialViewController = UIStoryboard.initialViewController(for: .main)
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()

    }
    
    // MARK: - Helper Functions
    func handleTapGesture(gesture: UITapGestureRecognizer) {
        print("handleTapGesture activated")
        photoHelper.presentActionSheet(from: self)
    }
    
    func getCurrentCityLocation() 
    {
        Location.getLocation(accuracy: .city, frequency: .oneShot, success: { (_, location) -> (Void) in
        print("Latitide: \(location.coordinate.latitude)")
        print("Longitude: \(location.coordinate.longitude)")
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        Location.getPlacemark(forLocation: location, success: { placemarks -> (Void) in
        //print(placemarks)
        guard let currentCityLoc = placemarks.first?.locality else { return }
        self.locationButton.titleLabel?.text = currentCityLoc
        // print(placemarks.first?.locality)
        }, failure: { error -> (Void) in
        print("Cannot retrive placemark due to an error \(error)")
        })
        }, error: { (request, last, error) -> (Void) in
        request.cancel()
        print("Location monitoring failed due to an error \(error)")
        })
        
//        let locationStr = self.locationButton.titleLabel?.text
//        guard let location = locationStr else {return ""}
//        return location
    }
    
//    func showAlert()
//    {
//        let alertVC = PMAlertController(title: "Locate your current city", description: "Enables access to your location: \n Discover Savvy members near you", image: UIImage(named: ""), style: .alert)
//        
//        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
//            print("Capture action Cancel")
//        }))
//        
//        //TODO: add progress bar
//        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
//            Location.getLocation(accuracy: .city, frequency: .oneShot, success: { (_, location) -> (Void) in
//                print("Latitide: \(location.coordinate.latitude)")
//                print("Longitude: \(location.coordinate.longitude)")
//                let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//                Location.getPlacemark(forLocation: location, success: { placemarks -> (Void) in
//                    //print(placemarks)
//                    guard let currentCityLoc = placemarks.first?.locality else { return }
//                    self.locationButton.titleLabel?.text = currentCityLoc
//                    // print(placemarks.first?.locality)
//                }, failure: { error -> (Void) in
//                    print("Cannot retrive placemark due to an error \(error)")
//                })
//            }, error: { (request, last, error) -> (Void) in
//                request.cancel()
//                print("Location monitoring failed due to an error \(error)")
//            })
//        }))
//        
//        self.present(alertVC, animated: true, completion: nil)
//        
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
