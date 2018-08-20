//
//  UserProfileController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    let userRef = FirebaseAPI.shared.databaseRef.child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserProfileStyling()
        
        fetchUser()
    }
    
    // MARK: Set Up Functions
    
    fileprivate func setupUserProfileStyling() {
        collectionView?.backgroundColor = .white
    } // setupUserProfileStyling
    
    fileprivate func fetchUser() {
        // Ensure we're able to fetch the current user's uid
        guard let uid = FirebaseAPI.shared.auth.currentUser?.uid else { return }
        
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (snapshot) in
            guard let valuesDict = snapshot.value as? [String: Any] else { return }
            guard let username = valuesDict["username"] as? String else { return }
            
            self.navigationItem.title = username
        }
    } // fetchUser
    
} // UserProfileController
