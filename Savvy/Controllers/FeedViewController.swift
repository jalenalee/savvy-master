//
//  FeedViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/15/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    var postCategArray = [Post]()
    var category = String()

    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        print(category)
        
        CategoriesService.posts(for: category) { posts in
            self.postCategArray = posts
            print(self.postCategArray)
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
            
        }
        
        prepareSwipe()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func prepareSwipe()
    {
        let swipeFromBottom = UISwipeGestureRecognizer(target: self, action: #selector(FeedViewController.leftSwiping(_:)))
        swipeFromBottom.direction = .right
        view.addGestureRecognizer(swipeFromBottom)
        
    }
    
    func leftSwiping(_ gesture:UIGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let post = postCategArray[indexPath.item]
        
        let storyboard = UIStoryboard.init(name: "Post", bundle: nil)
        let postVC = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
        let url = URL(string: post.videoURL)
        postVC.videoURL = url
        postVC.post = post
        navigationController?.pushViewController(postVC, animated: true)

    }
}

extension FeedViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return postCategArray.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        let post = postCategArray[indexPath.row]
        print(post)
        let imageURL = URL(string: post.imageSnapURL)
        cell.imageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = post.title
        
        return cell
    }

}

extension FeedViewController: UICollectionViewDelegateFlowLayout
{
    //we use the number of columns to calculate the item size of each UICollectionViewCell. This guarentees we'll have a evenly sized 3x3 row regardless of the device we're using.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 2
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemHeight = (collectionView.bounds.width - totalHorizontalSpacing) / columns + 20
        let newItemSize = CGSize(width: itemWidth, height: itemHeight)
        return newItemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
}
