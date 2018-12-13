//
//  UserProfileController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserProfileController: UICollectionViewController {
  
  fileprivate let headerID = "headerID"
  fileprivate let cellID   = "cellID"
  fileprivate let homePostCellID = "homePostCellID"
  
  var userId: String?
  var user: User?
  var posts: [Post] = []
  var isGridView = true
  
  static let updateFeedNotificationName = NSNotification.Name(rawValue: "updateUserFeed")
  
  // MARK: - Lifecycle Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    setupLogoutButton()
    retrieveUser()
  }
  
  // MARK: - Set Up Functions
  
  fileprivate func setupCollectionView() {
    collectionView?.backgroundColor = .white
    collectionView?.register(UserProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    collectionView?.register(UserProfilePostCell.self, forCellWithReuseIdentifier: cellID)
    collectionView?.register(HomePostViewCell.self, forCellWithReuseIdentifier: homePostCellID)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView?.refreshControl = refreshControl
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: UserProfileController.updateFeedNotificationName, object: nil)
  }
  
  fileprivate func setupLogoutButton() {
    let image = #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal)
    let action = #selector(handleGearButtonPressed)
    let gearButton = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
    navigationItem.rightBarButtonItem = gearButton
  }
  
  // MARK: - Selector Functions
  
  @objc func handleGearButtonPressed() {
    let alertController = UIAlertController(
      title: "",
      message: "Are you sure you want to logout?",
      preferredStyle: .actionSheet
    )
    
    let logoutHandler: (UIAlertAction) -> Void = { (_) in
      do {
        try Auth.auth().signOut()
        print("Successfully logged out")
        
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true)
      } catch let error {
        print("There was an error attempting to logout: \(error.localizedDescription)")
      }
    }
    
    let logoutAction = UIAlertAction(title: "Logout", style: .destructive, handler: logoutHandler)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alertController.addAction(logoutAction)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  @objc func handleRefresh() {
    print("handling refresh")
    posts.removeAll()
    guard self.user != nil else { return }
    retrieveUserPosts()
  }
  
  // MARK: - Helper Functions
  
  fileprivate func retrieveUser() {
    guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
    let uid = userId ?? currentUUID
    
    FirebaseAPI.shared.retrieveUserWith(uid: uid) { (user, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let user = user else { return }
      self.user = user
      self.navigationItem.title = user.username
      
      if user.uuid != currentUUID {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.title = nil
      }
      
      DispatchQueue.main.async {
        self.collectionView?.reloadData()
      }
      
      self.retrieveUserPosts()
    }
  }
  
  /// Fetches the user information for the current logged in user
  fileprivate func retrieveUserPosts() {
    guard let user = self.user else { return }
    
    FirebaseAPI.shared.retrieveUserPosts(user: user) { (posts, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard var posts = posts else { return }
      posts.sort(by: {
        $0.creationDate.compare($1.creationDate) == .orderedDescending
      })
      self.posts = posts
      
      DispatchQueue.main.async {
        self.collectionView?.refreshControl?.endRefreshing()
        self.collectionView?.reloadData()
      }
    }
  }
  
  func updateUserPosts() {
    handleRefresh()
  }
  
}

// MARK: - UICollectionViewDelegate

extension UserProfileController {
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if isGridView {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? UserProfilePostCell else {
        fatalError("Unable to unwrap UserProfilePostCell")
      }
      if (0..<posts.count) ~= indexPath.item {
        cell.post = posts[indexPath.item]
      }
      return cell
    } else {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellID, for: indexPath) as? HomePostViewCell else {
        fatalError("Unable to unwrap HomePostViewCell")
      }
      if (0..<posts.count) ~= indexPath.item {
        cell.post = posts[indexPath.item]
        cell.delegate = self
      }
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
  
  // MARK: CollectionView Header Functions
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! UserProfileHeaderView
    header.user = user
    header.delegate = self
    header.updateLabel(of: .posts, with: posts.count)
    
    guard let uuid = user?.uuid else { return header }
    let currentUUID = FirebaseAPI.shared.getCurrentUserUID()
    
    if uuid != currentUUID {
      FirebaseAPI.shared.fetchFollowingListForCurrentUser { (following, error) in
        if let error = error {
          print("Error: \(error) \n Description: \(error.localizedDescription)")
          return
        }
        
        guard let following = following else { return }
        if let _ = following.index(of: uuid) {
          header.updateFollowButtonConfiguration(isFollowing: true)
        } else {
          header.updateFollowButtonConfiguration(isFollowing: false)
        }
      }
    }
    
    return header
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - UserProfileHeaderDelegate

extension UserProfileController: UserProfileHeaderDelegate {
  
  func userProfileHeaderEditOrFollowButtonTapped(_ userProfileHeaderView: UserProfileHeaderView) {
    guard let uid = userProfileHeaderView.user?.uuid else { return }
    
    if userProfileHeaderView.editProfileFollowButton.title(for: .normal)?
      .compare("Edit Profile") == .orderedSame {
      // edit profile
    } else if userProfileHeaderView.editProfileFollowButton.title(for: .normal)?
      .compare("Follow") == .orderedSame {
      FirebaseAPI.shared.followUserWithUID(uid) { (error) in
        if let error = error {
          print(error)
          userProfileHeaderView.updateFollowButtonConfiguration(isFollowing: false)
          return
        }
        
        userProfileHeaderView.updateFollowButtonConfiguration(isFollowing: true)
      }
    } else {
      FirebaseAPI.shared.unfollowUserWithUID(uid) { (error) in
        if let error = error {
          print(error)
          userProfileHeaderView.updateFollowButtonConfiguration(isFollowing: true)
          return
        }
        
        userProfileHeaderView.updateFollowButtonConfiguration(isFollowing: false)
      }
    }
  }
  
  func userProfileHeaderGearButtonTapped(_ userProfileHeaderView: UserProfileHeaderView) {
    isGridView = true
    collectionView?.reloadData()
  }
  
  func userProfileHeaderListButtonTapped(_ userProfileHeaderView: UserProfileHeaderView) {
    isGridView = false
    collectionView?.reloadData()
  }
  
}

extension UserProfileController: HomePostViewCellDelegate {
  
  func didTapCommentButton(post: Post) {
    print("didTapCommentButton")
    guard let user = self.user else { return }
    
    let layout = UICollectionViewFlowLayout()
    let commentsController = PostCommentsController(collectionViewLayout: layout)
    commentsController.post = post
    commentsController.user = user
    navigationController?.pushViewController(commentsController, animated: true)
  }
  
  func didTapLikeButton(forCell: HomePostViewCell) {
    print("didTapLikeButton(forCell:)")
    guard let indexPath = collectionView?.indexPath(for: forCell) else { return }
    guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
    
    var post = self.posts[indexPath.item]
    let values = [currentUUID: !post.isLiked]
    
    FirebaseAPI.shared.updateLikesForPost(post, values: values) { (error) in
      if let error = error {
        print(error)
        return
      }
      
      post.isLiked = !post.isLiked
      self.posts[indexPath.item] = post
      self.collectionView?.reloadItems(at: [indexPath])
    }
  }
  
  func didTapShareButton(forCell: HomePostViewCell) {
    let vc = UIActivityViewController(activityItems: [forCell.postImageView.image!], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
  
}
