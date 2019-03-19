//
//  HomeFeedDataSource.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2019-03-19.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class HomeFeedDataSource: NSObject {
    
    private let user: User
    private(set) var posts: [Post] = []
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    var reuseId: String {
        return "HomePostViewCell"
    }
    
    func item(for index: Int) -> Post? {
        guard !posts.isEmpty else {
            return nil
        }
        
        return posts[index]
    }
    
    func toggleIsLikedForPost(at index: Int) {
        posts[index].isLiked.toggle()
    }
    
    func getItems(completion: @escaping (() -> Void)) {
        posts.removeAll()
        fetchPosts(for: user)
        fetchFollowingPosts(completion: completion)
    }
    
    private func fetchFollowingPosts(completion: @escaping (() -> Void)) {
        FirebaseAPI.shared.retrieveListOf(.following, uuid: user.uuid) { [unowned self] (following, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let following = following else {
                return
            }
            
            following.forEach {
                FirebaseAPI.shared.retrieveUserWith(uid: $0) { (user, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let user = user else {
                        return
                    }
                    
                    self.fetchPosts(for: user)
                }
            }
        }
    }
    
    private func fetchPosts(for user: User) {
        FirebaseAPI.shared.retrieveUserPosts(user: user) { [unowned self] (posts, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let posts = posts else {
                return
            }
            
            self.posts.append(contentsOf: posts)
            self.posts.sort { $0.creationDate > $1.creationDate }
        }
    }
    
}

extension HomeFeedDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? HomePostViewCell else {
            fatalError("Unable to unwrap HomePostViewCell")
        }
        
        cell.post = posts[indexPath.item]
        cell.delegate = collectionView.
        
        return cell
    }
}
