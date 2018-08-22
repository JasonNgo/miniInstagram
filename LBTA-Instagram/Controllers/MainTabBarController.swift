//
//  MainTabBarController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarStyling()
        setupViewControllers()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTabBarStyling() {
        view.backgroundColor = .white
        tabBar.tintColor = .black
    }
    
    fileprivate func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        viewControllers = [
            createNavigationController(rootViewController: userProfileController, title: "User Profile",
                                       selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"))
//            SignUpViewController()
        ]
    }
 
    // MARK: - Helper Functions
    
    fileprivate func createNavigationController(rootViewController: UIViewController, title: String,
                                                selectedImage: UIImage, unselectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        rootViewController.navigationItem.title = title
        
        navController.tabBarItem.image = unselectedImage.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        
        return navController
    }
    
} // MainTabBarController
