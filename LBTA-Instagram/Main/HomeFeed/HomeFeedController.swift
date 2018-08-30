//
//  HomeFeedController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-25.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class HomeFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var user: User?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        setupNavigationBar()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostViewCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchUserInfo()
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostViewCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    // MARK: - Helper Functions
    
    fileprivate func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    fileprivate func fetchUserInfo() {
        let uid = FirebaseAPI.shared.getCurrentUserUID()
        
        FirebaseAPI.shared.fetchUserWith(uid: uid) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let user = user else { return }
            self.user = user
        }
    }

//    fileprivate func fetchPosts() {
//        guard let user = self.user else { return }
//
//        FirebaseAPI.shared.fetchUserPosts(user: user) { (post, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            guard let post = post else { return }
//
//            self.posts.append(post)
//
//            DispatchQueue.main.async {
//                self.collectionView?.reloadData()
//            }
//        }
//    }
    
}
