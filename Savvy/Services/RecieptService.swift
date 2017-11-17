//
//  RecieptService.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/20/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct RecieptService
{
    static func create(title: String, jobDescription: String, postUser: User)
    {
        //Create new post in database
        
        // 1
        // Create a reference to the current user. We'll need the user's UID to construct the location od where we'll store our post data in our database
        let postUser = postUser
        
        //Initalize a new post using the data passed in by the parameters
        let reciept = Reciept(title: title, jobDescription: jobDescription, postUserUID: postUser.uid, assignedJobUser: postUser)
        
        // Convert the new post object into a dictionary so that it can be written as JSON to our dictionary
        let dict = reciept.dictValue
        
        // 4
        // Construct the relative path to the location where we want to store the new post data.
        // Notice that we're using the current user's UID as child nodes to keep track of which Post belongs to which user
        let postRef = Database.database().reference().child("reciepts").child(User.current.uid).childByAutoId()
        
        //Uploading childs by converting value into dictionary
        postRef.updateChildValues(dict)
    }
}
