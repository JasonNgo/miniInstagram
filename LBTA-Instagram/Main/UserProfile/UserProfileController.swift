//
//  UserProfileController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController, UserProfileHeaderDelegate {
    
    fileprivate let headerID = "headerID"
    fileprivate let cellID   = "cellID"
    fileprivate let homePostCellID = "homePostCellID"
    
    var user: User?
    var userId: String?
    var posts = [Post]()
    var isGridView = true
    
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
        collectionView?.register(HomePostViewCell.self, forCellWithReuseIdentifier: homePostCellID)
        collectionView?.register(UserProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    fileprivate func setupLogoutButton() {
        let gearButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleGearButtonPressed))
        navigationItem.rightBarButtonItem = gearButton
    }
    
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
    } // handleGearButtonPressed
    
    // MARK: - UserProfileHeaderDelegate
    
    func didTapGridButton() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    func didTapListButton() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfilePostCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellID, for: indexPath) as! HomePostViewCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            return CGSize(width: (view.frame.width - 2) / 3, height: (view.frame.width - 2) / 3)
        } else {
            var height: CGFloat = 40 + 8 + 8
            height += view.frame.width
            height += 50
            height += 60
            
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // MARK: Header Functions
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! UserProfileHeaderView
        header.user = self.user
        header.delegate = self
        return header
    }
    
    // MARK: - Helper Functions
    
    fileprivate func fetchUser() {
        guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
        let uid = userId ?? currentUUID
        
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let user = user else { return }
            self.user = user
            self.navigationItem.title = self.user?.username
            
            if self.user?.uuid.compare(currentUUID) != .orderedSame {
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.title = nil
            }
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
            self.fetchUserPosts()
        }
    } // fetchUser
    
    /// Fetches the user information for the current logged in user
    fileprivate func fetchUserPosts() {
        guard let user = self.user else { return }
        FirebaseAPI.shared.fetchUserPosts(user: user) { (posts, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard var posts = posts else { return }
            posts.sort(by: { $0.creationDate.compare($1.creationDate) == .orderedDescending })
            self.posts = posts
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    } // fetchUserPosts
    
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
