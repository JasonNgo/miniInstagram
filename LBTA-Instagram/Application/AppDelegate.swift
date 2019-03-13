//
//  AppDelegate.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {    
    var window: UIWindow?
    var applicationCoordinator: ApplicationCoordinator?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let applicationCoordinator = ApplicationCoordinator(window: window)
        
        self.window = window
        self.applicationCoordinator = applicationCoordinator
        
        applicationCoordinator.start()
        return true
    }
}

