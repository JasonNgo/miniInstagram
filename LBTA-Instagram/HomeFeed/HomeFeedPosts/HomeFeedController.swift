//
//  HomeFeedController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-25.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomeFeedController: UICollectionViewController {
  
  fileprivate let cellId = "cellId"
  static let updateFeedNotificationName = NSNotification.Name(rawValue: "updateHomeFeed")
  
  var user: User?
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
    fetchUserInfo()
  }
  
  // MARK: - Setup Functions
  
  fileprivate func setupNavigationBar() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    let image = #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal)
    let cameraBarItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCameraPressed))
    navigationItem.leftBarButtonItem = cameraBarItem
  }
  
  fileprivate func setupCollectionView() {
    collectionView?.backgroundColor = .white
    collectionView?.register(HomePostViewCell.self, forCellWithReuseIdentifier: cellId)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView?.refreshControl = refreshControl
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: HomeFeedController.updateFeedNotificationName, object: nil)
  }
  
  // MARK: - Selector Functions
  
  @objc func handleRefresh() {
    print("handling refresh")
    posts.removeAll()
    guard let user = self.user else { return }
    fetchPostsFor(user: user)
    fetchFollowingPosts()
  }
  
  @objc func handleCameraPressed() {
    let cameraController = CameraController()
    present(cameraController, animated: true, completion: nil)
  }
  
  // MARK: - Helper Functions
  
  fileprivate func fetchUserInfo() {
    guard let uid = FirebaseAPI.shared.getCurrentUserUID() else { return }
    FirebaseAPI.shared.retrieveUserWith(uid: uid) { (user, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let user = user else { return }
      self.user = user
      
      DispatchQueue.main.async {
        self.collectionView?.reloadData()
      }
      
      self.fetchPostsFor(user: self.user!)
      self.fetchFollowingPosts()
    }
  }
  
  fileprivate func fetchFollowingPosts() {
    FirebaseAPI.shared.fetchFollowingListForCurrentUser { (following, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let following = following else { return }
      following.forEach({ (followingUserID) in
        FirebaseAPI.shared.retrieveUserWith(uid: followingUserID, completion: { (user, error) in
          if let error = error {
            print(error)
            return
          }
          
          guard let user = user else { return }
          self.fetchPostsFor(user: user)
        })
      })
    }
  }
  
  fileprivate func fetchPostsFor(user: User) {
    FirebaseAPI.shared.retrieveUserPosts(user: user) { (posts, error) in
      if let error = error {
        print(error)
        return
      }
      
      self.collectionView?.refreshControl?.endRefreshing()
      
      guard let posts = posts else { return }
      self.posts.append(contentsOf: posts)
      
      self.posts.sort(by: { (p1, p2) -> Bool in
        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
      })
      
      DispatchQueue.main.async {
        self.collectionView?.reloadData()
      }
    }
  }
  
}

// MARK: UICollectionViewDelegate

extension HomeFeedController: UICollectionViewDelegateFlowLayout {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostViewCell else {
      fatalError("Unable to unwrap HomePostViewCell")
    }
    
    if (0..<posts.count) ~= indexPath.item {
      cell.post = posts[indexPath.item]
      cell.delegate = self
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 40 + 8 + 8
    height += view.frame.width
    height += 50
    height += 60
    
    return CGSize(width: view.frame.width, height: height)
  }
  
}

// MARK: - HomePostViewCellDelegate

extension HomeFeedController: HomePostViewCellDelegate {
  
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
  
}
