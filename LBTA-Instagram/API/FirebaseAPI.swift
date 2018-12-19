//
//  FirebaseAPI.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Firebase
import UIKit

enum FirebaseAuthError: Error {
  case errorCreatingUser(Error)
  case errorRetrievingUUID
}

enum FirebaseDatabaseError: Error {
  case errorCreatingUserDetails(Error)
  case errorRetrievingUserDetails(Error)
  case errorRetrievingListOfUsers(Error)
  case errorRetrievingListOfFollowing
  case errorRetrievingUserPosts(Error)
  case errorUpdatingUserPostDetails(Error)
  case errorFollowingUser(String)
  case errorUnfollowingUser(String)
}

enum FirebaseStorageError: Error {
  case errorCreatingProfileImage(Error)
  case errorCreatingPost(Error)
  case errorCreatingPostImage(Error)
  case errorRetrievingImageDownloadURL(Error)
}

enum DataError: Error {
  case errorConvertingImageToData
  case errorUnwrappingDownloadURL
  case errorUnwrappingDictionary
}

class FirebaseAPI {
  
  enum FollowType: String {
    case following = "following"
    case followers = "followers"
  }
  
  static let shared = FirebaseAPI()

  func getCurrentUserUID() -> String? {
    return Auth.auth().currentUser?.uid
  }
  
  // MARK: - User Creation Functions
  
  func createUserWithValues(_ values: [String: Any], completion: @escaping (Error?) -> Void) {
    let username = values["username"] as? String ?? ""
    let email = values["email"] as? String ?? ""
    let password = values["password"] as? String ?? ""
    let image = values["profile_image"] as? UIImage ?? #imageLiteral(resourceName: "plus_photo")
    
    // attempt to create user within Firebase
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      if let error = error {
        completion(FirebaseAuthError.errorCreatingUser(error))
        return
      }
      
      // attempt to upload profile image to Firebase Storage
      self.createProfileImage(image, completion: { (downloadURL, error) in
        if let error = error {
          completion(error)
          return
        }
        
        guard let downloadURL = downloadURL else {
          completion(DataError.errorUnwrappingDownloadURL)
          return
        }
        
        guard let uuid = result?.user.uid else {
          completion(FirebaseAuthError.errorRetrievingUUID)
          return
        }
        
        let values = [
          "uuid": uuid,
          "username": username,
          "profile_image_url": downloadURL
        ] as [String: Any]
        
        self.createUserDetails(with: values, completion: { (error) in
          if let error = error {
            completion(error)
            return
          }
          
          print("successfully saved user info to Database")
          completion(nil)
        })
      })
    }
  }
  
  // MARK: User Creation Helpers
  
  fileprivate func createProfileImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
    let fileName = NSUUID().uuidString
    let profileImagesRef = Storage.storage().reference().child("profile_images/\(fileName)")
    
    guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {
      completion(nil, DataError.errorConvertingImageToData)
      return
    }
    
    profileImagesRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
      if let error = error {
        completion(nil, FirebaseStorageError.errorCreatingProfileImage(error))
        return
      }
      
      profileImagesRef.downloadURL(completion: { (downloadURL, error) in
        if let error = error {
          completion(nil, FirebaseStorageError.errorRetrievingImageDownloadURL(error))
          return
        }
        
        guard let downloadURL = downloadURL else {
          completion(nil, DataError.errorUnwrappingDownloadURL)
          return
        }
        
        print("successfully fetched download URL: \(downloadURL.absoluteString)")
        completion(downloadURL.absoluteString, nil)
      })
    })
  }
  
  fileprivate func createUserDetails(with values: [String: Any], completion: @escaping (Error?) -> Void) {
    let usersRef = Database.database().reference().child("users")
    let uid = values["uuid"] as? String ?? ""
    
    usersRef.child(uid).updateChildValues(values) { (error, reference) in
      if let error = error {
        completion(FirebaseDatabaseError.errorCreatingUserDetails(error))
        return
      }
      
      completion(nil)
    }
  }
  
  // MARK: - Database Functions
  
  func retrieveUserWith(uid: String, completion: @escaping (User?, Error?) -> Void) {
    let usersRef = Database.database().reference().child("users")
    usersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      guard let values = snapshot.value as? [String: Any] else {
        completion(nil, DataError.errorUnwrappingDictionary)
        return
      }
      
      completion(User(dictionary: values), nil)
    }) { (error) in
      completion(nil, FirebaseDatabaseError.errorRetrievingUserDetails(error))
    }
  }
  
  func retrieveUserPosts(user: User, completion: @escaping ([Post]?, Error?) -> Void) {
    let uid = user.uuid
    let userPostsRef = Database.database().reference().child("posts").child(uid)
    var posts = [Post]()
    
    userPostsRef.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let values = snapshot.value, let dictionaries = values as? [String: Any] else {
        completion(nil, DataError.errorUnwrappingDictionary)
        return
      }
      
      dictionaries.forEach({ (key, value) in
        guard let valuesDict = value as? [String: Any] else {
          completion(nil, DataError.errorUnwrappingDictionary)
          return
        }
        
        var post = Post(user: user, valuesDict: valuesDict)
        post.postId = key
        
        guard let postId = post.postId else { return }
        guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
        
        let likesRef = Database.database().reference().child("likes").child(postId).child(currentUUID)
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
          if let value = snapshot.value as? Bool, value == true {
            post.isLiked = true
          } else {
            post.isLiked = false
          }
          
          posts.append(post)
          
          // final element has been updated, can now correctly call completion
          if dictionaries.count == posts.count {
            completion(posts, nil)
          }
        }, withCancel: { (error) in
          completion(nil, error)
        })
      })
    }) { (error) in
      completion(nil, FirebaseDatabaseError.errorRetrievingUserPosts(error))
    }
  }
  
  func retrieveListOfUsers(completion: @escaping ([User]?, Error?) -> Void) {
    let usersRef = Database.database().reference().child("users")
    var users = [User]()
    
    usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let values = snapshot.value, let dictionaries = values as? [String: Any] else {
        completion(nil, DataError.errorUnwrappingDictionary)
        return
      }
      
      dictionaries.forEach({ (key, value) in
        guard let dictionary = value as? [String: Any] else {
          completion(nil, DataError.errorUnwrappingDictionary)
          return
        }
        
        // don't include current logged user into search results
        if key == Auth.auth().currentUser?.uid { return }
        let user = User(dictionary: dictionary)
        users.append(user)
      })
      
      users.sort(by: { (u1, u2) -> Bool in
        return u1.username.compare(u2.username) == .orderedAscending
      })
      
      completion(users, nil)
    }) { (error) in
      completion(nil, FirebaseDatabaseError.errorRetrievingListOfUsers(error))
    }
  }
  
  // MARK: - Create Post Functions
  
  func createPost(postImage: UIImage, values: [String: Any], completion: @escaping (Error?) -> Void) {
    self.createPostImage(image: postImage) { (downloadURL, error) in
      if let error = error {
        completion(error)
        return
      }
      
      // attempt to save user info
      guard let downloadURL = downloadURL else { return }
      guard let uid = FirebaseAPI.shared.getCurrentUserUID() else { return }
      
      var valuesDict = values
      valuesDict["post_image_url"] = downloadURL
      
      let postRef = Database.database().reference().child("posts").child(uid).childByAutoId()
      postRef.updateChildValues(valuesDict) { (error, reference) in
        if let error = error {
          completion(FirebaseDatabaseError.errorUpdatingUserPostDetails(error))
          return
        }
        
        print("successfully saved post information to user")
        completion(nil)
      }
    }
  }
  
  // MARK: Create Posts Helper
  
  fileprivate func createPostImage(image: UIImage, completion: @escaping (String?, Error?) -> Void) {
    let fileName = NSUUID().uuidString
    guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {
      completion(nil, DataError.errorConvertingImageToData)
      return
    }
    
    let postsRef = Storage.storage().reference().child("post_images/\(fileName)")
    postsRef.putData(uploadData, metadata: nil) { (metadata, error) in
      if let error = error {
        completion(nil, FirebaseStorageError.errorCreatingPostImage(error))
        return
      }
      
      postsRef.downloadURL(completion: { (downloadURL, error) in
        if let error = error {
          completion(nil, FirebaseStorageError.errorRetrievingImageDownloadURL(error))
          return
        }
        
        guard let downloadURL = downloadURL else {
          completion(nil, DataError.errorUnwrappingDownloadURL)
          return
        }
        
        print("successfully fetched download URL: \(downloadURL.absoluteString)")
        completion(downloadURL.absoluteString, nil)
      })
    }
  }
  
  // MARK: Following/Unfollowing Functions
  
  func isCurrentUserFollowingUserWith(uuid: String, completion: @escaping (Bool, Error?) -> Void) {
    guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
    let followingRef = Database.database().reference().child("following").child(currentUUID).child(uuid)
    
    followingRef.observeSingleEvent(of: .value) { (snapshot) in
      guard let value = snapshot.value else {
        completion(false, FirebaseDatabaseError.errorRetrievingListOfFollowing)
        return
      }
      
      // Was able to retrieve
      guard let castedValue = value as? Bool, castedValue == true else {
        completion(false, nil)
        return
      }
      
      completion(true, nil)
    }
  }
  
  func retrieveListOf(_ type: FollowType, uuid: String, completion: @escaping ([String]?, Error?) -> Void) {
    let reference = Database.database().reference().child(type.rawValue).child(uuid)
    var follows: [String] = []
    
    reference.observe(.value, with: { (snapshot) in
      guard let values = snapshot.value else {
        completion([], FirebaseDatabaseError.errorRetrievingListOfFollowing)
        return
      }
      
      guard let valuesDict = values as? [String: Any] else {
        completion([], nil)
        return
      }
      
      valuesDict.keys.forEach { follows.append($0) }
      completion(follows, nil)
    }) { (error) in
      completion(nil, FirebaseDatabaseError.errorRetrievingListOfUsers(error))
    }
  }
  
  func followUserWithUID(_ uidToFollow: String, completion: @escaping (Error?) -> Void) {
    guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
    
    let followingRef = Database.database().reference().child("following").child(currentUUID)
    let followingValues = [uidToFollow: true] as [String: Any]
    followingRef.updateChildValues(followingValues) { (error, database) in
      if let _ = error {
        completion(FirebaseDatabaseError.errorFollowingUser("uidToFollow: \(uidToFollow)"))
        return
      }
      
      let followersRef = Database.database().reference().child("followers").child(uidToFollow)
      let followersValues = [currentUUID: true] as [String: Any]
      followersRef.updateChildValues(followersValues) { (error, database) in
        if let _ = error {
          completion(FirebaseDatabaseError.errorFollowingUser("currentUUID: \(currentUUID)"))
          return
        }
        
        completion(nil)
      }
    }
    
  }
  
  func unfollowUserWithUID(_ uidToUnfollow: String, completion: @escaping (Error?) -> Void) {
    guard let currentUUID = FirebaseAPI.shared.getCurrentUserUID() else { return }
    
    let followingRef = Database.database().reference().child("following").child(currentUUID).child(uidToUnfollow)
    followingRef.removeValue { (error, _) in
      if let _ = error {
        completion(FirebaseDatabaseError.errorUnfollowingUser("uidToUnfollow: \(uidToUnfollow)"))
        return
      }
      
      let followersRef = Database.database().reference().child("followers").child(uidToUnfollow).child(currentUUID)
      followersRef.removeValue(completionBlock: { (error, _) in
        if let _ = error {
          completion(FirebaseDatabaseError.errorUnfollowingUser("currentUUID: \(currentUUID)"))
          return
        }
        
        completion(nil)
      })
    }
  }
  
  // MARK: - Post Actions
  
  func saveCommentToDatabaseForPost(_ post: Post, values: [String: Any], completion: @escaping (Error?) -> Void) {
    guard let postId = post.postId else { return }
    let commentRef = Database.database().reference().child("comments").child(postId).childByAutoId()
    
    commentRef.updateChildValues(values) { (error, reference) in
      if let error = error {
        print(error)
        completion(error)
        return
      }
      
      print("saved comment")
      completion(nil)
    }
  }
  
  func updateLikesForPost(_ post: Post, values: [String: Any], completion: @escaping (Error?) -> Void) {
    guard let postId = post.postId else { return }
    let likesRef = Database.database().reference().child("likes").child(postId)
    
    likesRef.updateChildValues(values) { (error, reference) in
      if let error = error {
        print(error)
        completion(error)
        return
      }
      
      print("updated likes")
      completion(nil)
    }
  }
  
  func fetchCommentsForPost(_ post: Post, completion: @escaping ([Comment]?, Error?) -> Void) {
    guard let postId = post.postId else { return }
    
    var comments = [Comment]()
    
    let commentsRef = Database.database().reference().child("comments").child(postId)
    commentsRef.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let values = snapshot.value, let commentDictionaries = values as? [String: Any] else {
        completion(nil, DataError.errorUnwrappingDictionary)
        return
      }
      
      commentDictionaries.forEach({ (key, value) in
        guard let dictionary = value as? [String: Any] else {
          completion(nil, DataError.errorUnwrappingDictionary)
          return
        }
        
        let comment = Comment(dictionary: dictionary)
        comments.append(comment)
      })
      
      comments.sort(by: { (c1, c2) -> Bool in
        return c1.creationDate.compare(c2.creationDate) == .orderedAscending
      })
      
      completion(comments, nil)
    }) { (error) in
      completion(nil, error)
    }
  }
  
}
