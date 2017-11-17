//
//  Post.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/1/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Post
{
    var key: String?
    var videoURL : String
    var imageSnapURL: String
    var title: String
    var postDescription: String
    var creationDate : Date
    var category : String
    let poster: User
    
    init(title : String, postDescription:String, category: String, videoURL: String, imageSnapURL: String)
    {
        self.title = title
        self.postDescription = postDescription
        self.category = category
        self.videoURL = videoURL
        self.creationDate = Date()
        self.imageSnapURL = imageSnapURL
        self.poster = User.current
    }
    
    // Failable initializer
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let videoURL = dict["videoURL"] as? String,
            let imageSnapURL = dict["imageURL"] as? String,
            let title = dict["title"] as? String,
            let postDescription = dict["postDescription"] as? String,
            let category = dict["category"] as? String,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String,
            let fullname = userDict["fullname"] as? String,
            let userDescription = userDict["userDescription"] as? String,
            let location = userDict["location"] as? String,
            let email = userDict["email"] as? String
            else {return nil}
        
        self.key = snapshot.key
        self.videoURL = videoURL
        self.imageSnapURL = imageSnapURL
        self.title = title
        self.postDescription = postDescription
        self.category = category
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.poster = User(uid: uid, username: username, fullname: fullname, userDescription: userDescription, email: email, location: location)
    }
    
    // Failable initializer
    init?(key: String, postDictionary: [String : Any]) {
        //var dict : [String : Any]
        //print(postDictionary as? [String:])
        let dict = postDictionary
        print(dict)
        let videoURL = dict["videoURL"] as? String ?? ""
        let imageSnapURL = dict["imageURL"] as? String ?? ""
        let title = dict["title"] as? String ?? ""
        let postDescription = dict["postDescription"] as? String ?? ""
        let category = dict["category"] as? String ?? ""
        let createdAgo = dict["created_at"] as? TimeInterval ?? nil
        let userDict = dict["poster"] as? [String : Any] ?? nil
        let uid = userDict?["uid"] as? String ?? ""
        let username = userDict?["username"] as? String ?? ""
        let fullname = userDict?["fullname"] as? String ?? ""
        let userDescription = userDict?["userDescription"] as? String ?? ""
        let location = userDict?["location"] as? String ?? ""
        let email = userDict?["email"] as? String ?? ""
    
        
        self.key = key
        self.videoURL = videoURL
        self.imageSnapURL = imageSnapURL
        self.title = title
        self.postDescription = postDescription
        self.category = category
        self.creationDate = Date(timeIntervalSince1970: createdAgo!)
        self.poster = User(uid: uid, username: username, fullname: fullname, userDescription: userDescription, email: email, location: location)
    }
    
    
     //Convenient for turning our Post object into dictionaries of type [String: Any]
    
    var dictValue: [String : Any]
    {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = [ "uid" : poster.uid,
                         "username" : poster.username,
                         "fullname" : poster.fullname,
                         "userDescription" : poster.userDescription,
                         "email" : poster.email,
                         "location" : poster.location]

        return ["videoURL" : videoURL,
                "imageURL" : imageSnapURL,
                "title"    : title,
                "postDescription" : postDescription,
                "category" : category,
                "created_at" : createdAgo,
                "poster" : userDict]
    }
    
    
}
