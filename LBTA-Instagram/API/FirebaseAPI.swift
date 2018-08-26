//
//  FirebaseAPI.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Firebase
import UIKit

enum UserCreationError: Error {
    case unableToCreateUID
    case unableToUploadProfileImage
    case unableToFetchDownloadURL
    case unableToFetchCurrentUserUID
    case unableToSaveProfileInformationToDatabase
    case dataError
}

enum LoginError: Error {
    case unableToLogin
}

enum LogoutError: Error {
    case unableToLogout
}

enum FetchUserInfoError: Error {
    case unableToFetchUserUID
    case unableToFetchUserData
    case unableToFetchUserPosts
    case dataError
}

enum SavePostError: Error {
    case unableToFetchUserUID
    case unableToSavePostImage
    case unableToFetchImageDownloadURL
    case unableToSavePostInformation
    case dataError
}

class FirebaseAPI {
    
    static let shared = FirebaseAPI()
    
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    let auth = Auth.auth()
    
    func getCurrentUserUID() -> String? {
        return auth.currentUser?.uid
    }
    
    // MARK: - User Creation
    
    func createUserWith(email: String, username: String, password: String, profileImage: UIImage, completion: @escaping (UserCreationResult) -> Void) {
        
        // attempt to create a new user
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print(error)
                completion(.failure(UserCreationError.unableToCreateUID))
                return
            }
            
            // attempt to upload user profile picture
            self.uploadProfileImage(profileImage, completion: { (error, downloadURL) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // attempt to save user profile information to database
                guard let downloadURL = downloadURL else {
                    completion(.failure(UserCreationError.dataError))
                    return
                }
                
                let values = ["username": username, "profile_image_url": downloadURL]
                self.saveUserProfileInfoToDatabase(values: values, completion: { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success)
                }) // saveUserProfileInfoToDatabase
            }) // uploadProfileImage()
        } // createUser(withEmail:password:)
        
    } // createUserWith(email:username:password:profileImage:)
    
    // MARK: User Creation Helpers
    
    /// Attempts to upload an Image to Firebase Storage. returns an error if failed and success otherwise into completion
    /// - parameter image: Image that is being saved to Firebase Storage
    /// - parameter completion: Closure that gets executed. Contains an error on failure and nil otherwise
    
    fileprivate func uploadProfileImage(_ image: UIImage, completion: @escaping (UserCreationError?, String?) -> Void) {
        
        let fileName = NSUUID().uuidString
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {
            completion(UserCreationError.dataError, nil)
            return
        }
        
        let profileImagesRef = storageRef.child("profile_images/\(fileName)")
        profileImagesRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("error attempting to upload image to Storage: \(error)")
                completion(UserCreationError.unableToUploadProfileImage, nil)
                return
            }
            
            profileImagesRef.downloadURL(completion: { (downloadURL, error) in
                if let error = error {
                    print("error fetching downloadURL: \(error)")
                    completion(UserCreationError.unableToFetchDownloadURL, nil)
                    return
                }
                
                guard let downloadURL = downloadURL else {
                    print("Unable to unwrap download URL:")
                    completion(UserCreationError.dataError, nil)
                    return
                }
                
                print("successfully fetched download URL: \(downloadURL.absoluteString)")
                completion(nil, downloadURL.absoluteString)
            }) // downloadURL
        }) // putData
        
    } // uploadProfileImage
    
    fileprivate func saveUserProfileInfoToDatabase(values: [String: Any], completion: @escaping (UserCreationError?) -> Void) {
        
        guard let uid = FirebaseAPI.shared.getCurrentUserUID() else {
            completion(UserCreationError.unableToFetchCurrentUserUID)
            return
        }
        
        databaseRef.child("users").child(uid).updateChildValues(values) { (error, reference) in
            if let error = error {
                print("error attempting to save user profile information to Database: \(error)")
                completion(UserCreationError.unableToSaveProfileInformationToDatabase)
                return
            }
            
            print("successfully saved user info to Database")
            completion(nil)
        } // updateChildValues
        
    } // saveUserProfileInfoToDatabase
    
    // MARK: - Login Functions
    
    func loginUserWith(email: String, password: String, completion: @escaping (LoginResult) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { (dataResult, error) in
            if let err = error {
                print("error attempting to login email: \(email): \(err)")
                completion(.failure(LoginError.unableToLogin))
                return
            }
            
            guard let _ = dataResult else { return }
            completion(.success)
        }
        
    } // loginUserWith
    
    // MARK: - Logout Functions
    
    func logoutUser(completion: @escaping (LogoutResult) -> Void) {
        do {
            try auth.signOut()
            completion(.success)
        } catch let error {
            print("error attempting to logout: \(error)")
            completion(.failure(LogoutError.unableToLogout))
        }
    } // logoutUser
    
    // MARK: - Fetch Profile Functions
    
    func fetchUserWith(uid: String, completion: @escaping (DataSnapshot?, FetchUserInfoError?) -> Void) {
        
        let usersRef = databaseRef.child("users")
        
        usersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot, nil)
        }) { (error) in
            print("error attempting to fetch user with uid: \(uid), error: \(error)")
            completion(nil, FetchUserInfoError.unableToFetchUserData)
        }
        
    }
    
    func fetchUserPosts(user: User, completion: @escaping (Post?, FetchUserInfoError?) -> Void) {
        
        guard let uid = getCurrentUserUID() else {
            print("unable to fetch current user uid")
            completion(nil, FetchUserInfoError.unableToFetchUserUID)
            return
        }
        
        let userPostsRef = databaseRef.child("posts").child(uid)
    
        userPostsRef.queryOrdered(byChild: "creation_date").observe(.childAdded, with: { (snapshot) in
            guard let values = snapshot.value else {
                completion(nil, FetchUserInfoError.dataError)
                return
            }
            
            guard let dictionary = values as? [String: Any] else {
                completion(nil, FetchUserInfoError.dataError)
                return
            }
            
            let post = Post(user: user, valuesDict: dictionary)
            completion(post, nil)
            
        }) { (error) in
            print(error)
            completion(nil, FetchUserInfoError.unableToFetchUserPosts)
        }
        
    } // fetchUserPosts
    
    // MARK: - Save Post Functions
    
    func savePostToFirebase(postImage: UIImage, values: [String: Any], completion: @escaping (SharePhotoResult) -> Void) {
        
        self.savePostImageToStorage(image: postImage) { (downloadURL, error) in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            
            // attempt to save user info
            guard let downloadURL = downloadURL else {
                completion(.failure(SavePostError.dataError))
                return
            }
            
            guard let uid = FirebaseAPI.shared.getCurrentUserUID() else {
                completion(.failure(SavePostError.unableToFetchUserUID))
                return
            }
            
            var valuesDict = values
            valuesDict["post_image_url"] = downloadURL
            
            self.databaseRef.child("posts").child(uid).childByAutoId().updateChildValues(valuesDict) { (error, reference) in
                if let error = error {
                    print("error attempting to save post info to user: \(error)")
                    completion(.failure(SavePostError.unableToSavePostInformation))
                    return
                }
                
                print("successfully saved post information to user")
                completion(.success)
            }
        } // savePostImageToStorage
        
    } // savePostToFirebase
    
    // MARK: Save Posts Helper
    
    fileprivate func savePostImageToStorage(image: UIImage, completion: @escaping (String?, SavePostError?) -> Void) {
        
        let fileName = NSUUID().uuidString
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {
            completion(nil, SavePostError.dataError)
            return
        }
        
        let postsRef = storageRef.child("post_images/\(fileName)")
        postsRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("error attempting to upload post image to storage: \(error)")
                completion(nil, SavePostError.unableToSavePostImage)
                return
            }
            
            postsRef.downloadURL(completion: { (downloadURL, error) in
                if let error = error {
                    print("error attempting to fetch post image download URL: \(error)")
                    completion(nil, SavePostError.unableToFetchImageDownloadURL)
                    return
                }
                
                guard let downloadURL = downloadURL else {
                    print("Unable to unwrap downloadURL")
                    completion(nil, SavePostError.dataError)
                    return
                }
                
                print("successfully fetched download URL: \(downloadURL.absoluteString)")
                completion(downloadURL.absoluteString, nil)
            }) // downloadURL
        } // putData
        
    } // savePostImageToStorage

} // FirebaseAPI
