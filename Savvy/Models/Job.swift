//
//  Job.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/13/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Job
{
    
    var key: String?
    var title : String
    var jobDescription: String
    var creationDate : Date
    var sender: User
    var postUser : User
    var postUserUID: String
    
    init(title:String, jobDescription: String, postUserUID: String, postUser: User)
    {
        self.title = title
        self.jobDescription = jobDescription
        self.postUserUID = postUserUID
        self.creationDate = Date()
        self.sender = User.current
        self.postUser = postUser
    }
    
    // Failable initializer
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let postUserUID = dict["postUserUID"] as? String,
            let title = dict["title"] as? String,
            let jobDescription = dict["jobDescription"] as? String,
            let createdAgo = dict["created_at"] as? TimeInterval,
            // JOB Sender
            let userDict = dict["sender"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String,
            let fullname = userDict["fullname"] as? String,
            let userDescription = userDict["userDescription"] as? String,
            let email = userDict["email"] as? String,
            // JOB Assigned too
            let assigneeUserDict = dict["assignedUser"] as? [String : Any],
            let assigneeUid = assigneeUserDict["uid"] as? String,
            let assigneeUsername = assigneeUserDict["username"] as? String,
            let assigneeFullname = assigneeUserDict["fullname"] as? String,
            let assigneeUserDescription = assigneeUserDict["userDescription"] as? String,
            let assigneeEmail = assigneeUserDict["email"] as? String
            else {return nil}
        
        
        
        self.key = snapshot.key
        self.title = title
        self.jobDescription = jobDescription
        self.postUserUID = postUserUID
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.sender = User(uid: uid, username: username, fullname: fullname, userDescription: userDescription, email: email)
        self.postUser = User(uid: assigneeUid, username: assigneeUsername, fullname: assigneeFullname, userDescription: assigneeUserDescription, email: assigneeEmail)
    }
    
    //Convenient for turning our Job object into dictionaries of type [String: Any]
    
    var dictValue: [String : Any]
    {
        let createdAgo = creationDate.timeIntervalSince1970
        
        let userDict = [ "uid" : sender.uid,
                         "username" : sender.username,
                         "fullname" : sender.fullname,
                         "userDescription" : sender.userDescription,
                         "email" : sender.email]
        
        let assignedUserDict = [ "uid" : postUser.uid,
                                 "username" : postUser.username,
                                 "fullname" : postUser.fullname,
                                 "userDescription" : postUser.userDescription,
                                 "email" : postUser.email]
        
        return ["title" : title,
                "postUserUID" : postUserUID,
                "jobDescription" : jobDescription,
                "created_at" : createdAgo,
                "sender" : userDict,
                "assignedUser" : assignedUserDict]
    }
    
    
    
}
