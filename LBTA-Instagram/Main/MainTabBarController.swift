
//
//  MainTabBarController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // user not logged in
        if FirebaseAPI.shared.auth.currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        
        // UITabBarControllerDelegate
        self.delegate = self
        
        setupTabBarStyling()
        setupViewControllers()
    }
    
    // MARK: - Setup Functions
    
    func setupTabBarStyling() {
        view.backgroundColor = .white
        tabBar.tintColor = .black
    }
    
    func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        
        // home
        let homeController = HomeFeedController(collectionViewLayout: layout)
        let homeNavController = createNavigationController(rootViewController: homeController,
                                                           title: "Home",
                                                           selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"))
        // search
        let searchController = UserSearchController(collectionViewLayout: layout)
        let searchNavController = createNavigationController(rootViewController: searchController,
                                                             title: "",
                                                             selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"))
        // photo picker
        let photoPickerController = UIViewController()
        let photoNavController = createNavigationController(rootViewController: photoPickerController,
                                                            title: "Photo",
                                                            selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        // like
        let likeController = UIViewController()
        let likeNavController = createNavigationController(rootViewController: likeController,
                                                           title: "Likes",
                                                           selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        // profile
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = createNavigationController(rootViewController: userProfileController,
                                                                  title: "User Profile",
                                                                  selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"))
        
        viewControllers = [
            homeNavController,
            searchNavController,
            photoNavController,
            likeNavController,
            userProfileNavController
        ]
        
        guard let items = tabBar.items else { return }
        items.forEach { (item) in
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
        // test to see if commits will show
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            showPhotoSelectorController()
            return false
        }
        
        return true
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
    
    fileprivate func showPhotoSelectorController() {
        let layout = UICollectionViewFlowLayout()
        let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
        let navPhotoSelector = UINavigationController(rootViewController: photoSelectorController)
        present(navPhotoSelector, animated: true)
    }
    
} // MainTabBarController
