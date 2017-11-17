//
//  User.swift
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class User : NSObject {
    
    //User variables
    let uid : String
    let email : String
    let fullname : String
    let username : String
    let userDescription : String
    var location: String
    var image : String
    
    var dictValue: [String : Any] {
        return ["fullName" : fullname,
                "username" : username,
                "userDescription" : userDescription,
                "email" : email,
                "location" : location,
                "image" : image]
    }
    
    //Standard User init()
    init(uid: String, username: String, fullname : String, userDescription: String, email: String, location: String = "", image: String = "") {
        self.uid = uid
        self.fullname = fullname
        self.username = username
        self.userDescription = userDescription
        self.location = location
        self.email = email
        self.image = image
        super.init()
    }
    
    //User init using Firebase snapshots
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let location = dict["location"] as? String,
            let fullname = dict["fullname"] as? String,
            let username = dict["username"] as? String,
            let email  = dict["email"] as? String,
            let userDescription = dict["userDescription"] as? String,
            let image = dict["image"] as? String
            else { return nil }
        self.uid = snapshot.key
        self.location = location
        self.fullname = fullname
        self.username = username
        self.userDescription = userDescription
        self.email = email
        self.image = image
    }
    
    //UserDefaults
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let fullname = aDecoder.decodeObject(forKey: "fullname") as? String,
            let username = aDecoder.decodeObject(forKey: "username") as? String,
            let userDescription = aDecoder.decodeObject(forKey: "userDescription") as? String,
            let location = aDecoder.decodeObject(forKey: "location") as? String,
            let email = aDecoder.decodeObject(forKey: "email") as? String,
            let image = aDecoder.decodeObject(forKey: "image") as? String
            else { return nil }
        
        self.uid = uid
        self.fullname = fullname
        self.location = location
        self.username = username
        self.email = email
        self.userDescription = userDescription
        self.image = image
    }
    
    init?(key: String, userDictionary: [String : Any]) {
        let dict = userDictionary
        print(dict)
        let location = dict["location"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let fullname = dict["fullname"] as? String ?? ""
        let username = dict["username"] as? String ?? ""
        let userDescription = dict["userDescription"] as? String ?? ""
        let image = dict["image"] as? String ?? ""
        
        self.uid = key
        self.location = location
        self.fullname = fullname
        self.username = username
        self.userDescription = userDescription
        self.email = email
        self.image = image
    }

    
    
    //User singleton for currently logged user
    private static var _current: User?
    
    // User object current
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    // Function to update current user properties and save them to User Defaults
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
        
        _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(fullname, forKey: "fullname")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(userDescription, forKey: "userDescription")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(image, forKey: "image")
    }
}
