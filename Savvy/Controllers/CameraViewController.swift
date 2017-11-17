//
//  CameraViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 7/28/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import SwiftyCam
import UIKit
import RecordButton

class CameraViewController: SwiftyCamViewController {
    
    
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: UIButton!
    var cancelButton: UIButton!
    var progressTimer: Timer?
    var progress : CGFloat! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the camera delegate
        cameraDelegate = self
        // Setting maximum duration for video
        //maximumVideoDuration = 60.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = false
        audioEnabled = true
        addButtons()
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureButton.isSelected = true
        //Hiding tab bar to allow the Camera view to be full screen
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Action Functions (Buttons)
    
    // Function which controls the camera switch button
    @objc private func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    
    // Function which controls the flash button
    @objc private func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        }
    }
    
    // Function which controls the cancel button
    @objc private func cancel()
    {
        
        self.tabBarController?.selectedIndex = 0
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    // Function which controls that capture button
    @objc private func captureAction(_ sender: Any)
    {
    
        if captureButton.isSelected == true
        {
            startVideoRecording()
            
             //captureButton.addTarget(self, action: #selector(record), for: .touchDown)
           // self.progressTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            print("Started recording")
          // captureButton.backgroundColor = UIColor.red
            //stopVideoRecording()
            
            captureButton.isSelected = false
            //captureButton.buttonColor = UIColor.black
        }
        else
        {
            
            //captureButton.backgroundColor = UIColor.darkGray
            //captureButton.addTarget(self, action: #selector(stop), for: UIControlEvents.touchUpInside)
            //captureButton.buttonColor = UIColor.darkGray
            stopVideoRecording()
            print("Stopped recording")
        }
    }
    
    @objc func update()
    {
        stopVideoRecording()
        //captureButton.backgroundColor = UIColor.black
    }
    
    // Adding buttons programatically to the Camera view
    private func addButtons() {
        captureButton = UIButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 70.0, height: 70.0))
        let image = UIImage(named: "capture_photo")
        captureButton.setImage(image, for: UIControlState.normal)
//        captureButton.backgroundColor = UIColor.da
        //captureButton.buttonColor = UIColor.darkGray
        captureButton.addTarget(self, action: #selector(captureAction(_:)), for: .touchUpInside)
//        captureButton.addTarget(self, action: #selector(record), for: .touchDown)
//        captureButton.addTarget(self, action: #selector(stop), for: UIControlEvents.touchUpInside)
        self.view.addSubview(captureButton)
        //captureButton.delegate = self
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
        
        cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    func record() {
        
        
        self.progressTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func updateProgress() {
        
        let maxDuration = CGFloat(5) // max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        //captureButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer?.invalidate()
        }
        
    }
    
    func stop() {
        self.progressTimer?.invalidate()
    }
}

// MARK: - SwiftyCamViewControllerDelegate
extension CameraViewController : SwiftyCamViewControllerDelegate
{
    //Allows camera to take images if allowed
    /*
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        print("Took picture")
    }
    */
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }

    //Functin called when startVideoRecording() is called
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        //print("Did Begin Recording")
        // captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
            self.cancelButton.alpha = 0.0
        })
    }
    
    // Function called when stopVideoRecording() is called
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        //print("Did finish Recording")
        // captureButton.shrinkButton()
        self.progressTimer?.invalidate()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
            self.cancelButton.alpha = 1.0
        })
    }
    
    // Function called once recorded has stopped. The URL for the video gets returned here.
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // I am passing the url to VideoViewController to show the video
        let newVC = VideoViewController(videoURL: url)
        self.navigationController?.pushViewController(newVC, animated: true)
        //self.present(newVC, animated: true, completion: nil)
    }
    
    // Function which allows you to zoom. Added animation for User/UI purposes
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
}
