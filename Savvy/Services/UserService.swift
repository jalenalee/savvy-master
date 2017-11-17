//
//  UserService.swift
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

struct UserService {
    
    static func create(_ firUser: FIRUser, username: String, fullname: String, userDescription: String, email: String, completion: @escaping (User?) -> Void) {
        
        
//        let imageRef = StorageReference.newPostImageReference()
//        var urlString = ""
//        guard let image = profileImage else { return }
//        
        let userAttrs = ["username": username,
                         "fullname" : fullname,
                         "userDescription": userDescription,
                         "email" : email,
                         "location" : "",
                         "image" : ""]
        
        
//        StorageService.uploadImage(image, at:imageRef ) { (downloadURL) in
//            guard let downloadURL = downloadURL else {
//                return
//            }
//            
//            urlString = downloadURL.absoluteString
//            // We want to store the aspect heigh because when we render our image, we'll need to know the height of the image to display. We do this by calculating what the height of the image should be based on the maximum width and height of an ihpone
//            //let aspectHeight = image.aspectHeight
//            //create(forURLString: urlString, aspectHeight: aspectHeight)
//            
//           
//        }
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
//    static func uploadProfilePicture(user:User, image: UIImage)
//    {
//        
//        let username = user.username
//        let
//        
//        let userAttrs = ["username": username,
//                         "fullname" : fullname,
//                         "userDescription": userDescription,
//                         "location" : location,
//                         "email" : email,
//                         "image" : urlString]
//
//        
//        let ref = Database.database().reference().child("users").child(User.current.uid)
//        ref.updateChildValues(userAttrs)
//    }
    
    static func edit(fullname: String, username: String, userDescription: String, location: String?, profileImage: UIImage?, completion: @escaping (User?) -> Void) {
        
        //TODO: Add email
        
        let placeholderImage = UIImage(named:"user")
        
        if profileImage != nil && profileImage != placeholderImage {
        
             let imageRef = StorageReference.newPostImageReference()
            
            StorageService.uploadImage(profileImage!, at:imageRef ) { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
                
                //TODO: Add email
                let userAttrs = ["username": username,
                                 "fullname" : fullname,
                                 "location" : location!,
                                 "userDescription": userDescription,
                                 "image" : downloadURL.absoluteString]
                    as [String : Any]
                
                // We want to store the aspect heigh because when we render our image, we'll need to know the height of the image to display. We do this by calculating what the height of the image should be based on the maximum width and height of an ihpone
                //let aspectHeight = image.aspectHeight
                //create(forURLString: urlString, aspectHeight: aspectHeight)
                let ref = Database.database().reference().child("users").child(User.current.uid)
                //Updating valus of current user
                ref.updateChildValues(userAttrs) { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        return completion(nil)
                    }
                    // Retreiving values in real time and updating in app
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        let user = User(snapshot: snapshot)
                        completion(user)
                    })
                }

                
            }
        }
        else
        {
            let userAttrs = ["username": username,
                             "fullname" : fullname,
                             "location" : location!,
                             "userDescription": userDescription,
                             "image" : ""]
                as [String : Any]
            
            let ref = Database.database().reference().child("users").child(User.current.uid)
            //Updating valus of current user
            ref.updateChildValues(userAttrs) { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                // Retreiving values in real time and updating in app
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    completion(user)
                })
            }

        }

    }
    
    static func editProfileImage(url: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["profilePic": url]

        let ref = Database.database().reference().child("users").child(User.current.uid)
        ref.updateChildValues(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }

            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    //fetch users by getting snapshot
    static func fetchUsers(forUID uid: String, completion: @escaping (User?) -> Void) {
        
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
        
    }
    
    //Fetch User posts
    //Service method that will retrieve all of a user's posts from Firebase. This will be the data we display in our timeline
    static func posts(for user: User, completion: @escaping ([Post]) -> Void)
    {
        //Getting firebase root directory
        let ref = Database.database().reference().child("posts")
        
        // Getting snapshot from firebase directory
        //ref.observe(.value, with: { (snapshot) in
        let query = ref.queryOrdered(byChild: "poster/uid").queryEqual(toValue: User.current.uid)
        query.observe(.value, with: { (snapshot) in
            print(snapshot)
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            print(snapshot)
            
            // Checking whether each of our posts is liked by the current user
            
            // We use dispatch groups to wait for all of of the asynchronous code to complete before sshead
            //let dispatchGroup = DispatchGroup()
            
            
            let posts: [Post] =
                snapshot
                    .reversed()      // Reverses array
                    .flatMap {       // Returns array with non nil values
                        guard let post = Post(snapshot: $0)
                            else { return nil }
                        
                        //                        dispatchGroup.enter()
                        //                        // Now each post that is returned with our posts(for:completion:) service method will have data on whether the current user has liked it or not.
                        //                        LikeService.isPostLiked(post) { (isLiked) in
                        //                            post.isLiked = isLiked
                        //                            
                        //                            dispatchGroup.leave()
                        //                        }
                        
                        return post
            }
            completion(posts)
            //            dispatchGroup.notify(queue: .main, execute: {
            //                completion(posts)
            //            })
        })
    }
    
    //Service method that will retrieve all of a user's posts from Firebase. This will be the data we display in our timeline
    static func jobs(for user: User, completion: @escaping ([Job]) -> Void)
    {
        //Getting firebase root directory
        let ref = Database.database().reference().child("jobs").child(user.uid)
        
        // Getting snapshot from firebase directory
        ref.observe(.value, with: { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            print(snapshot)
            
            // Checking whether each of our posts is liked by the current user
            
            // We use dispatch groups to wait for all of of the asynchronous code to complete before sshead
            let dispatchGroup = DispatchGroup()
            
            
            let jobs: [Job] =
                snapshot
                    .reversed()      // Reverses array
                    .flatMap {       // Returns array with non nil values
                        guard let post = Job(snapshot: $0)
                            else { return nil }
                        
                        //                        dispatchGroup.enter()
                        //                        // Now each post that is returned with our posts(for:completion:) service method will have data on whether the current user has liked it or not.
                        //                        LikeService.isPostLiked(post) { (isLiked) in
                        //                            post.isLiked = isLiked
                        //
                        //                            dispatchGroup.leave()
                        //                        }
                        
                        return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(jobs)
            })
        })
    }
    
    static func reciepts(for user: User, completion: @escaping ([Reciept]) -> Void)
    {
        //Getting firebase root directory
        print(user)
        print(user.uid)
        let ref = Database.database().reference().child("reciepts").child(user.uid)
        
        // Getting snapshot from firebase directory
        ref.observe(.value, with: { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            print(snapshot)
            
            // Checking whether each of our posts is liked by the current user
            
            // We use dispatch groups to wait for all of of the asynchronous code to complete before sshead
            let dispatchGroup = DispatchGroup()
            
            
            let reciepts: [Reciept] =
                snapshot
                    .reversed()      // Reverses array
                    .flatMap {       // Returns array with non nil values
                        guard let post = Reciept(snapshot: $0)
                            else { return nil }
                        
                        //                        dispatchGroup.enter()
                        //                        // Now each post that is returned with our posts(for:completion:) service method will have data on whether the current user has liked it or not.
                        //                        LikeService.isPostLiked(post) { (isLiked) in
                        //                            post.isLiked = isLiked
                        //
                        //                            dispatchGroup.leave()
                        //                        }
                        
                        return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(reciepts)
            })
        })
    }


//    static func fetchUserPosts(for user: User, completion: @escaping ([Post]) -> Void)
//    {
//        // Getting firebase directory
//        let ref = Database.database().reference().child("posts").child(user.uid)
//       
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
//                return completion([])
//            }
//            
//            
//            
//            let posts: [Post] =
//                snapshot
//                    .reversed()
//                    .flatMap {
//                        guard let post = Post(snapshot: $0) else { return nil }
//                        return post
//            }
//            
//            completion(posts)
//        })
//        
//    }
    
    
    static func deleteUser(forUID uid: String, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("users")
        let object = [uid : NSNull()]
        ref.updateChildValues(object) { (error, ref) -> Void in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return success(false)
            }
            return success(true)
        }
        
    }
    
    // Retrieve data to provide content for a given user's profile. We'll return the user object and all of the user's posts from Firebase.
    static func observeProfile(for user: User, completion: @escaping (DatabaseReference, User?, [Post], [Job],[Reciept]) -> Void) -> DatabaseHandle
    {
        // 1 Create a reference to the location we want to read the user object from.
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        // 2 Observer the DatabaseReference to retrieve the user object.
        return userRef.observe(.value, with: { (snapshot) in
            // 3 Check that the data returned is a valid user. If not, return an empty completion block.
            guard let user = User(snapshot: snapshot) else { return completion(userRef, nil, [],[],[])}
            
            // 4 Retrieve all posts for the respective user.
            posts(for: user, completion: { posts in
                // 5 Return the completion block with a reference to the DatabaseReference, user, and posts, jobs, reciepts if successful.
                jobs(for: user, completion: { allJobs in
                    
                    reciepts(for: user, completion: { allReciepts in
                        
                        completion(userRef, user, posts,allJobs, allReciepts)
                    })
                })
            })
        })
    }
}
