//
//  HomeFeedController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-25.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomeFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostViewCellDelegate {
    
    fileprivate let cellId = "cellId"
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "updateFeed")
    
    var user: User?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        setupNavigationBar()
        setupCollectionView()
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: HomeFeedController.updateFeedNotificationName, object: nil)
        
        fetchUserInfo()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        let cameraBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCameraPressed))
        navigationItem.leftBarButtonItem = cameraBarItem
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostViewCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    // MARK: - HomePostViewCellDelegate
    
    func didTapCommentButton(post: Post) {
        print("didTapCommentButton")
        print(post.caption)
        let layout = UICollectionViewFlowLayout()
        let commentsController = PostCommentsController(collectionViewLayout: layout)
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    // MARK: - Selector Functions
    
    @objc func handleRefresh() {
        print("handling refresh")
        posts.removeAll()
        guard let user = self.user else { return }
        fetchPostsFor(user: user)
        fetchFollowingPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleCameraPressed() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    fileprivate func fetchUserInfo() {
        let uid = FirebaseAPI.shared.getCurrentUserUID()
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (user, error) in
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
                FirebaseAPI.shared.fetchUserWith(uid: followingUserID, completion: { (user, error) in
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
        FirebaseAPI.shared.fetchUserPosts(user: user) { (posts, error) in
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
    
} // HomeFeedController
