//
//  UserProfileController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

enum LogoutResult {
    case success
    case failure(Error)
}

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let headerID = "headerID"
    fileprivate let cellID = "cellID"
    
    var userId: String?
    var user: User? {
        didSet {
            navigationItem.title = user?.username
            
            guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
            if currentUUID == user?.uuid {
                followButton.makeHidden()
            } else {
                FirebaseAPI.shared.fetchListOfFollowersForCurrentUser { (followers) in
                    
                    guard let followers = followers else { return }
                    if let _ = followers.index(of: self.user?.uuid ?? "") {
                        self.followButton.title = "Unfollow"
                    } else {
                        self.followButton.title = "Follow"
                    }
                    
                    self.followButton.makeVisible()
                }
            }
        }
    }
    var posts = [Post]()
    
    lazy var followButton: UIBarButtonItem = {
        var button = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(handleFollowPressed))
        button.makeHidden()
        return button
    }()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfilePostCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(UserProfileHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerID)
        
        // setup logout
        setupLogoutButton()
        
        fetchUser()
    }
    
    // MARK: - Set Up Functions
    
    fileprivate func setupLogoutButton() {
        let gearButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain,
                                         target: self, action: #selector(handleGearButtonPressed))
        navigationItem.rightBarButtonItems = [gearButton, followButton]
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
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID,
                                                                     for: indexPath) as! UserProfileHeaderView
        if let user = self.user {
            header.user = user
        }
        
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
    
    @objc func handleFollowPressed() {
        print("follow/unfollow pressed")
        
        if followButton.title?.compare("Follow") == .orderedSame {
            guard let uidToFollow = user?.uuid else { return }
            FirebaseAPI.shared.followUserWithUID(uidToFollow) { (result) in
                switch result {
                case .success:
                    self.followButton.title = "Unfollow"
                case .failure:
                    self.followButton.title = "Follow"
                }
            }
        } else {
            guard let uidToUnfollow = user?.uuid else { return }
            FirebaseAPI.shared.unfollowUserWithUID(uidToUnfollow) { (result) in
                switch result {
                case .success:
                    self.followButton.title = "Follow"
                case .failure:
                    self.followButton.title = "Unfollow"
                }
            }
            
        }
    }
    
    // MARK: - Helper Functions
    
    fileprivate func fetchUser() {
        
        let uid = userId ?? (FirebaseAPI.shared.getCurrentUserUID() ?? "")
        
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let snapshot = snapshot else { return }
            guard let valuesDict = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: valuesDict)
            self.collectionView?.reloadData()
            
            self.fetchUserPosts()
        }
        
    } // fetchUser
    
    fileprivate func fetchUserPosts() {
        
        guard let user = self.user else { return }
        
        FirebaseAPI.shared.fetchUserPosts(user: user) { (post, error) in
            if let error = error {
                self.collectionView?.reloadData() // reload user details
                print(error)
                return
            }
            
            guard let post = post else { return }
            
            self.posts.append(post)
            self.collectionView?.reloadData()
        }
        
    } // fetchUserPosts
    
    fileprivate func checkFollowStatus() {
        
    }
    
} // UserProfileController
