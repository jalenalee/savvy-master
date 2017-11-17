//
//  PostDetailViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/12/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import ISHPullUp
import Firebase

class PostDetailViewController : UIViewController, ISHPullUpSizingDelegate, ISHPullUpStateDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var handleView: ISHPullUpHandleView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var hireButton: UIButton!
    private var firstAppearanceCompleted = true
    weak var pullUpController: ISHPullUpViewController!
    var post : Post?
  
    // we allow the pullUp to snap to the half way point
    private var halfWayPoint = CGFloat(0)
    
    override func viewDidLoad() {

        super.viewDidLoad()
        setupUserInteraction()
        //handleView.state = .down
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        topView.addGestureRecognizer(tapGesture)
       // usernameButton.setTitle(User.current.username, for: UIControlState())
        topView.backgroundColor = UIColor(white: 0, alpha: 0.0)
  
        
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearanceCompleted = true;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        pullUpController.setState(.collapsed, animated: true)
        pullUpController.snapThreshold = 0.50
        
        
        let username = post?.poster.username
        let postDescription = post?.postDescription
        // Capitializing Title when recieving from Firebase
        let postTitle = post?.title.capitalized
        usernameButton.setTitle(username, for: UIControlState())
        titleLabel.text = postTitle
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        descriptionLabel.text = postDescription
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.sizeToFit()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Helper functions
    private dynamic func handleTapGesture(gesture: UITapGestureRecognizer) {
        
        pullUpController.toggleState(animated: false)
    }

    fileprivate func setupUserInteraction()
    {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else{
        return
        }
        guard let uid = post?.poster.uid else{
        return
        }
        
        
        if currentLoggedInUser == uid {
            DispatchQueue.main.async {
                self.hireButton.isHidden = true
            }
        } else{
            DispatchQueue.main.async {
                self.hireButton.isHidden = false
            }
        }
    }

    
    // MARK: - IBActions
    @IBAction func hireButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Hire", bundle: nil)
        let hireVC = storyboard.instantiateViewController(withIdentifier: "HireViewController") as! HireViewController
        hireVC.postUser = post?.poster
        PostViewController.player?.replaceCurrentItem(with: nil)
        self.navigationController?.pushViewController(hireVC, animated: true)
    }
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        
        let totalHeight = self.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        // we allow the pullUp to snap to the half way point
        // we "calculate" the cached value here
        // and perform the snapping in ..targetHeightForBottomViewController..
        //halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    //Set the minimum height to show
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        
        
        return topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height;
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        // if around 30pt of the half way point -> snap to it
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        
        // default behaviour
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
        // we update the scroll view's content inset
        // to properly support scrolling in the intermediate states
        ///
        //
//        scrollView.contentInset = edgeInsets;
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        
        
        //topLabel.text = textForState(state);
       // ISHPullUpHandleView.handleState
        self.handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
        
//        if pullUpViewController.state == .dragging
//        {
//            pullUpViewController.setState(.expanded, animated: true)
//        }
    }
    
//    private func textForState(_ state: ISHPullUpState) -> String {
//        switch state {
//        case .collapsed:
//            return "Drag up or tap"
//        case .intermediate:
//            return "Intermediate"
//        case .dragging:
//            return "Hold on"
//        case .expanded:
//            return "Drag down or tap"
//        }
//    }
}

