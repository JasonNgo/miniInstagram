
//
//  MainTabBarController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let homeFeedCoordinator: HomeFeedCoordinator
    private let userSearchCoordinator: UserSearchCoordinator
    
    private let userProfileCoordinator: UserProfileCoordinator
    
    // MARK: - Initializer
    init() {
        self.homeFeedCoordinator = HomeFeedCoordinator(navigationController: UINavigationController())
        self.userSearchCoordinator = UserSearchCoordinator(navigationController: UINavigationController())
        self.userProfileCoordinator = UserProfileCoordinator(navigationController: UINavigationController())
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
        setupViewControllers()
        setupCoordinators()
    }
    
    // MARK: - Setup Functions
    private func setupTabBarController() {
        view.backgroundColor = .white
        tabBar.tintColor = .black
        self.delegate = self
    }
    
    private func setupViewControllers() {
        let photoPickerController = UIViewController()
        let photoNavController = createNavigationController(
            rootViewController: photoPickerController,
            title: "Photo",
            selectedImage: #imageLiteral(resourceName: "camera3"),
            unselectedImage: #imageLiteral(resourceName: "camera3")
        )
        
        viewControllers = [
            homeFeedCoordinator.navigationController,
            userSearchCoordinator.navigationController,
            photoNavController,
            userProfileCoordinator.navigationController
        ]
        
        guard let items = tabBar.items else { return }
        items.forEach { (item) in
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func setupCoordinators() {
        homeFeedCoordinator.start()
        userSearchCoordinator.start()
        userProfileCoordinator.start()
    }
    
    // MARK: - Helper Functions
    
    private func createNavigationController(rootViewController: UIViewController, title: String, selectedImage: UIImage, unselectedImage: UIImage) -> UIViewController {
        rootViewController.navigationItem.title = title
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        
        return navController
    }
    
    private func showPhotoSelectorController() {
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

