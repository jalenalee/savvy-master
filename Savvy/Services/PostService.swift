//
//  PostService.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/1/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService
{
    
    static func create(postTitle: String,postDescription: String, category: String, videoURL: URL, image: UIImage)
    {
        let videoRef = StorageReference.newPostVideoReference()
        let imageRef = StorageReference.newPostImageReference()
        
        StorageService.uploadVideo(videoURL, at: videoRef) { (downloadURL) in
            
            guard let downloadURL = downloadURL else { return }
            
            let videoUrlString = downloadURL.absoluteString
            //Saving photo to new location generation
            
            
            
            StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                
                let urlString = downloadURL.absoluteString
                // We want to store the aspect heigh because when we render our image, we'll need to know the height of the image to display. We do this by calculating what the height of the image should be based on the maximum width and height of an ihpone
                //let aspectHeight = image.aspectHeight
                //create(forURLString: urlString, aspectHeight: aspectHeight)
                
                create(postTitle: postTitle, postDescription: postDescription, category: category, videoURL: videoUrlString, imageSnapURL: urlString)
            }

        }
        
//        //Saving photo to new location generation
//        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
//            guard let downloadURL = downloadURL else {
//                return
//            }
//            
//            let urlString = downloadURL.absoluteString
//            // We want to store the aspect heigh because when we render our image, we'll need to know the height of the image to display. We do this by calculating what the height of the image should be based on the maximum width and height of an ihpone
//            let aspectHeight = image.aspectHeight
//            //create(forURLString: urlString, aspectHeight: aspectHeight)
//        }
    }
    
    private static func create(postTitle: String,postDescription: String, category: String, videoURL: String, imageSnapURL: String)
    {
        //Create new post in database
        
        // 1
        // Create a reference to the current user. We'll need the user's UID to construct the location od where we'll store our post data in our database
        //let currentUser = User.current
        
        //Initalize a new post using the data passed in by the parameters
        let post = Post(title: postTitle, postDescription: postDescription, category: category, videoURL: videoURL, imageSnapURL: imageSnapURL)
        
        
        // Convert the new post object into a dictionary so that it can be written as JSON to our dictionary
        let dict = post.dictValue
//        let followData = ["posts/\(currentUser.uid)/\("")" : dict,
//                          "following/\(currentUser.uid)/\("")" : true]
        
        // 4
        // Construct the relative path to the location where we want to store the new post data.
        // Notice that we're using the current user's UID as child nodes to keep track of which Post belongs to which user
        let postRef = Database.database().reference().child("posts").childByAutoId()
        let categoriesRef = Database.database().reference().child("categories").child(category).childByAutoId()
        //let postTitleRef = Database.database().reference().child("post_titles")
        //Uploading childs by converting value into dictionary
        postRef.updateChildValues(dict)
        categoriesRef.updateChildValues(dict)
    }
    
//    static func createForSearchQuery()
//    {
//        //Create new post in database
//        
//        // 1
//        // Create a reference to the current user. We'll need the user's UID to construct the location od where we'll store our post data in our database
//        
//        //Initalize a new post using the data passed in by the parameters
//        let post = Post(title: postTitle, postDescription: postDescription, category: category, videoURL: videoURL, imageSnapURL: imageSnapURL)
//        
//        
//        // Convert the new post object into a dictionary so that it can be written as JSON to our dictionary
//        let dict = post.dictValue
//        //        let followData = ["posts/\(currentUser.uid)/\("")" : dict,
//        //                          "following/\(currentUser.uid)/\("")" : true]
//        
//        // 4
//        // Construct the relative path to the location where we want to store the new post data.
//        // Notice that we're using the current user's UID as child nodes to keep track of which Post belongs to which user
//        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
//        let categoriesRef = Database.database().reference().child("categories").child(category).childByAutoId()
//        //Uploading childs by converting value into dictionary
//        postRef.updateChildValues(dict)
//        categoriesRef.updateChildValues(dict)
//    }

}

