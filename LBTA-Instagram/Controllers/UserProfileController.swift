//
//  UserProfileController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let headerID = "headerID"
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up
        setupCollectionView()
        
        fetchUser()
    }
    
    // MARK: Set Up Functions
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerID)
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerID,
                                                                     for: indexPath) as! UserProfileHeaderView
        header.user = self.user
        
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - Helper Functions
    
    fileprivate func fetchUser() {
        // Ensure we're able to fetch the current user's uid
        guard let uid = FirebaseAPI.shared.auth.currentUser?.uid else { return }
        
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (snapshot) in
            guard let valuesDict = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: valuesDict)
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
        }
    }
    
} // UserProfileController
