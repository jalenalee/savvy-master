//
//  VideoHelper.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/7/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import AVFoundation

class VideoHelper: NSObject {
    
    // Function which allows you to take snapshot of video
    static func videoSnapshot(videoURL: String) -> UIImage?
    {
        let vidURL = URL(fileURLWithPath: videoURL)
        let asset = AVURLAsset(url: vidURL)
        //let asset = AVURLAsset(url: <#T##URL#>, options: <#T##[String : Any]?#>)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
}
