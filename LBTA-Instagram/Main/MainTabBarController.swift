
//
//  MainTabBarController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
  
  // MARK: - Overrides
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // user not logged in
    if Auth.auth().currentUser == nil {
      DispatchQueue.main.async {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true)
      }
      
      return
    }
    
    setupTabBarController()
    setupViewControllers()
  }
  
  // MARK: - Set Up Functions
  
  func setupTabBarController() {
    tabBar.tintColor = .black
    self.delegate = self
  }
  
  func setupViewControllers() {
    let homeFeedLayout = UICollectionViewFlowLayout()
    let homeController = HomeFeedController(collectionViewLayout: homeFeedLayout)
    let homeNavController = createNavigationController(
      rootViewController: homeController,
      title: "Home",
      selectedImage: #imageLiteral(resourceName: "home_selected"),
      unselectedImage: #imageLiteral(resourceName: "home_unselected")
    )
    
    let searchLayout = UICollectionViewFlowLayout()
    let searchController = UserSearchController(collectionViewLayout: searchLayout)
    let searchNavController = createNavigationController(
      rootViewController: searchController,
      title: "Search",
      selectedImage: #imageLiteral(resourceName: "search_selected"),
      unselectedImage: #imageLiteral(resourceName: "search_unselected")
    )
    
    let photoPickerController = UIViewController()
    let photoNavController = createNavigationController(
      rootViewController: photoPickerController,
      title: "Photo",
      selectedImage: #imageLiteral(resourceName: "camera3"),
      unselectedImage: #imageLiteral(resourceName: "camera3")
    )
    
    let likeController = UIViewController()
    let likeNavController = createNavigationController(
      rootViewController: likeController,
      title: "Likes",
      selectedImage: #imageLiteral(resourceName: "like_selected"),
      unselectedImage: #imageLiteral(resourceName: "like_unselected")
    )
    
    let userProfileLayout = UICollectionViewFlowLayout()
    let userProfileController = UserProfileController(collectionViewLayout: userProfileLayout)
    let userProfileNavController = createNavigationController(
      rootViewController: userProfileController,
      title: "User",
      selectedImage: #imageLiteral(resourceName: "profile_selected"),
      unselectedImage: #imageLiteral(resourceName: "profile_unselected")
    )
    
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
  }
  
  // MARK: - Helper Functions
  
  fileprivate func createNavigationController(rootViewController: UIViewController, title: String, selectedImage: UIImage, unselectedImage: UIImage) -> UIViewController {
    rootViewController.navigationItem.title = title
    
    let navController = UINavigationController(rootViewController: rootViewController)
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
  
}

extension MainTabBarController: UITabBarControllerDelegate {

  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if let index = viewControllers?.index(of: viewController), index == 2 {
      showPhotoSelectorController()
      return false
    }
    
    return true
  }

}
