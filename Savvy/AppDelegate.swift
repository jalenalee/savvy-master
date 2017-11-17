//
//  AppDelegate.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/14/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//


import UIKit
import Firebase
import SendGrid

typealias FIRUser = FirebaseAuth.User

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var apiKey = "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"
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().backgroundColor = UIColor(red: 245.0/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)]
        
        FirebaseApp.configure()
        configureInitialRootViewController(for: window)
        
        Session.shared.authentication = Authentication.apiKey(apiKey)
        return true
    }
    
}

extension AppDelegate {
    
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: "currentUser") as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
            
            User.setCurrent(user)
            
            initialViewController = UIStoryboard.initialViewController(for: .main)
        }
        else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

