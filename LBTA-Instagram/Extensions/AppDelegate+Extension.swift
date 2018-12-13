//
//  AppDelegate.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-12.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

extension AppDelegate {
  
  static var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  var mainTabBarController: MainTabBarController? {
    return window?.rootViewController as? MainTabBarController
  }
  
  var userProfileController: UserProfileController? {
    return (mainTabBarController?.viewControllers?[4] as? UINavigationController)?.viewControllers.first as? UserProfileController
  }
  
  var homeFeedController: HomeFeedController? {
    return (mainTabBarController?.viewControllers?[0] as? UINavigationController)?.viewControllers.first as? HomeFeedController
  }

}
