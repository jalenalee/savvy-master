//
//  CategoriesViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/16/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //Beauty
    @IBAction func categOneButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.category = (sender.titleLabel?.text)!
        
        // Passing the videoURL so I can store it in Firebase storage
        //self.present(addPostViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(feedViewController, animated: true)

    }
    //Music
    @IBAction func categTwoButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.category = (sender.titleLabel?.text)!
        // Passing the videoURL so I can store it in Firebase storage
        //self.present(addPostViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }
    //Art
    @IBAction func categThreeButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.category = (sender.titleLabel?.text)!
        // Passing the videoURL so I can store it in Firebase storage
        //self.present(addPostViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }
    //Automotive
    @IBAction func categFourButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.category = (sender.titleLabel?.text)!
        // Passing the videoURL so I can store it in Firebase storage
        //self.present(addPostViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }
    //Grooming
    @IBAction func categFiveButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.category = (sender.titleLabel?.text)!
        // Passing the videoURL so I can store it in Firebase storage
        //self.present(addPostViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(feedViewController, animated: true)
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
