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
    fileprivate let cellID = "cellID"
    
    var user: User?
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up
        setupCollectionView()
        
        fetchUser()
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        setupGearButton()
        
        collectionView?.register(UserProfileHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerID)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    fileprivate func setupGearButton() {
        let gearButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain,
                                         target: self, action: #selector(handleGearButtonPressed))
        navigationItem.rightBarButtonItem = gearButton
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: Header Functions
    
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
    
    // MARK: - Selector Functions
    
    @objc func handleGearButtonPressed() {
        let alertController = UIAlertController(title: "Logout?",
                                                message: "Are you sure you would like to logout?",
                                                preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            print("logout pressed")
            
            FirebaseAPI.shared.logoutUser(completionHandler: { (result) in
                if result {
                    // logout was successful
                    let loginController = LoginController()
                    let navController = UINavigationController(rootViewController: loginController)
                    self.present(navController, animated: true, completion: nil)
                } else {
                    // not successfull
                    print("not successful")
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
