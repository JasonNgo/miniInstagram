//
//  UserProfileController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController {
    
    fileprivate let headerID = "headerID"
    fileprivate let cellID   = "cellID"
    
    var user: User?
    var userId: String?
    var posts = [Post]()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupLogoutButton()
        
        fetchUser()
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfilePostCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(UserProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    fileprivate func setupLogoutButton() {
        let gearButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleGearButtonPressed))
        navigationItem.rightBarButtonItem = gearButton
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfilePostCell
        cell.post = posts[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // MARK: Header Functions
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! UserProfileHeaderView
        header.user = self.user
        return header
    }
    
    // MARK: - Selector Functions
    
    @objc func handleGearButtonPressed() {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            print("logout pressed")
            
            FirebaseAPI.shared.logoutUser(completion: { (error) in
                if let error = error {
                    print(error)
                    return
                }
                
                print("Successfully logged out")
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    fileprivate func fetchUser() {
        
        let uid = userId ?? FirebaseAPI.shared.getCurrentUserUID()
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let user = user else { return }
            self.user = user
            
            DispatchQueue.main.async {
                self.navigationItem.title = self.user?.username
                self.collectionView?.reloadData()
            }
            
            self.fetchUserPosts()
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

            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    } // fetchUserPosts
    
    fileprivate func checkFollowStatus() {
//        guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
//        if currentUUID == user?.uuid {
//            followButton.makeHidden()
//        } else {
//            navigationItem.rightBarButtonItems = [followButton]
//
//            FirebaseAPI.shared.fetchListOfFollowersForCurrentUser { (followers) in
//                guard let followers = followers else {
//                    self.followButton.makeVisible()
//                    self.followButton.title = "Follow"
//                    return
//                }
//
//                if let _ = followers.index(of: self.user?.uuid ?? "") {
//                    self.followButton.title = "Unfollow"
//                } else {
//                    self.followButton.title = "Follow"
//                }
//
//                self.followButton.makeVisible()
//            }
//        }
    }
    
} // UserProfileController

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
