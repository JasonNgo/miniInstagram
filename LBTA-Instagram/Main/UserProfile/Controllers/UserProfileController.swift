//
//  UserProfileController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import Firebase

enum LogoutResult {
    case success
    case failure(Error)
}

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let headerID = "headerID"
    fileprivate let cellID = "cellID"
    
    var user: User?
    
    var posts = [Post]()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up
        setupCollectionView()
        
        fetchUser()
        fetchUserPosts()
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        setupGearButton()
        
        collectionView?.register(UserProfileHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerID)
        
        collectionView?.register(UserProfilePostCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    fileprivate func setupGearButton() {
        let gearButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain,
                                         target: self, action: #selector(handleGearButtonPressed))
        navigationItem.rightBarButtonItem = gearButton
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfilePostCell
        
        cell.post = posts[indexPath.item]
        
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
        return posts.count
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
            
            FirebaseAPI.shared.logoutUser(completion: { (logoutResult) in
                
                switch logoutResult {
                case .success:
                    print("Successfully logged out")
                    
                    let loginController = LoginController()
                    let navController = UINavigationController(rootViewController: loginController)
                    self.present(navController, animated: true, completion: nil)
                    
                case let .failure(error):
                    print(error)
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
        
        guard let uid = FirebaseAPI.shared.getCurrentUserUID() else { return }
        
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let snapshot = snapshot else { return }
            guard let valuesDict = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: valuesDict)
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
        }
        
    } // fetchUser
    
    fileprivate func fetchUserPosts() {
        
        guard let user = self.user else { return }
        
        FirebaseAPI.shared.fetchUserPosts(user: user) { (post, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let post = post else { return }
            
            self.posts.append(post)
            self.collectionView?.reloadData()
        }
        
    } // fetchUserPosts
    
} // UserProfileController
