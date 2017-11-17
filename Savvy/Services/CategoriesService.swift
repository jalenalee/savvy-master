//
//  CategoriesService.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/16/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct CategoriesService
{
    // Get post by categories
    static func posts(for category: String, completion: @escaping ([Post]) -> Void)
    {
        //Getting firebase root directory
        let ref = Database.database().reference().child("categories").child(category)
        
        // Getting snapshot from firebase directory
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
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
}
