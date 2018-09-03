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
    case errorCreatingUser(String)
    case errorFetchingUUID(String)
    case errorSigningIn(String)
    case errorSigningOut(String)
}

enum FirebaseDatabaseError: Error {
    case errorCreatingUserDetails(String)
    case errorFetchingUserDetails(String)
    case errorFetchingListOfUsers(String)
    case errorFetchingUserPosts(String)
    case errorSavingUserPostDetails(String)
    case errorFollowingUser(String)
    case errorUnfollowingUser(String)
}

enum FirebaseStorageError: Error {
    case errorUploadingProfileImage(String)
    case errorFetchingImageDownloadURL(String)
    case errorSavingPost(String)
}

enum DataError: Error {
    case errorConvertingImage(String)
    case errorUnwrappingDownloadURL(String)
    case errorUnwrappingDictionary(String)
    case errorUnwrappingUsers(String)
}

class FirebaseAPI {
    
    static let shared = FirebaseAPI()
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getCurrentUserUID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - User Creation Functions
    
    func createUserWithValues(_ values: [String: Any], completion: @escaping (Error?) -> Void) {
        let username = values["username"] as? String ?? ""
        let email = values["email"] as? String ?? ""
        let password = values["password"] as? String ?? ""
        
        guard let image = values["profile_image"] as? UIImage else {
            completion(DataError.errorConvertingImage(""))
            return
        }
        
        // attempt to create user within Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG ERROR: /// \(error)")
                completion(FirebaseAuthError.errorCreatingUser("email: \(email)"))
                return
            }
            
            // attempt to upload profile image to Firebase Storage
            self.uploadProfileImage(image, completion: { (downloadURL, error) in
                if let error = error {
                    print(error)
                    completion(error)
                    return
                }
                
                guard let downloadURL = downloadURL else {
                    completion(DataError.errorUnwrappingDownloadURL(""))
                    return
                }
                
                guard let uuid = result?.user.uid else {
                    completion(FirebaseAuthError.errorFetchingUUID(""))
                    return
                }
                
                let values = ["uuid": uuid, "username": username, "profile_image_url": downloadURL] as [String: Any]
                self.saveUserDetailsWith(values: values, completion: { (error) in
                    if let error = error {
                        print(error)
                        completion(error)
                        return
                    }
                    
                    print("successfully saved user info to Database")
                    completion(nil)
                }) // saveUserDetails
            }) // uploadProfileImage
        } // createUser
    } // createUserWithValues
    
    // MARK: User Creation Helpers
    
    fileprivate func uploadProfileImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        let fileName = NSUUID().uuidString
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {
            completion(nil, DataError.errorConvertingImage("Unable to convert profile image to data"))
            return
        }
        
        let profileImagesRef = Storage.storage().reference().child("profile_images/\(fileName)")
        profileImagesRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("DEBUG ERROR: /// \(error)")
                completion(nil, FirebaseStorageError.errorUploadingProfileImage(""))
                return
            }
            
            profileImagesRef.downloadURL(completion: { (downloadURL, error) in
                if let error = error {
                    print("DEBUG ERROR: /// \(error)")
                    completion(nil, FirebaseStorageError.errorFetchingImageDownloadURL(""))
                    return
                }
                
                guard let downloadURL = downloadURL else {
                    completion(nil, DataError.errorUnwrappingDownloadURL(""))
                    return
                }
                
                print("successfully fetched download URL: \(downloadURL.absoluteString)")
                completion(downloadURL.absoluteString, nil)
            }) // downloadURL
        }) // putData
    } // uploadProfileImage
    
    fileprivate func saveUserDetailsWith(values: [String: Any], completion: @escaping (Error?) -> Void) {
        let usersRef = Database.database().reference().child("users")
        let uid = values["uuid"] as? String ?? ""
        
        usersRef.child(uid).updateChildValues(values) { (error, reference) in
            if let error = error {
                print("DEBUG ERROR: /// \(error)")
                completion(FirebaseDatabaseError.errorCreatingUserDetails(""))
                return
            }
            
            completion(nil)
        } // updateChildValues
    } // saveUserProfileInfoToDatabase
    
    // MARK: - Login Functions
    
    func loginUserWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG ERROR: /// \(error)")
                completion(FirebaseAuthError.errorSigningIn(""))
                return
            }
            
            guard result != nil else { return }
            completion(nil)
        } // signIn
    } // loginUserWith
    
    // MARK: - Logout Functions
    
    func logoutUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            print("DEBUG ERROR: /// \(error)")
            completion(FirebaseAuthError.errorSigningOut(""))
        }
    } // logoutUser
    
    // MARK: - Database Functions
    
    func fetchUserWith(uid: String, completion: @escaping (User?, Error?) -> Void) {
        let usersRef = Database.database().reference().child("users")
        
        usersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else {
                completion(nil, DataError.errorUnwrappingDictionary(""))
                return
            }
            
            let user = User(dictionary: values)
            completion(user, nil)
        }) { (error) in
            print("DEBUG ERROR: /// \(error)")
            completion(nil, FirebaseDatabaseError.errorFetchingUserDetails(""))
        } // observeSingleEvent
    } // fetchUserWith
    
    func fetchUserPosts(user: User, completion: @escaping (Post?, Error?) -> Void) {
        let uid = user.uuid
        let userPostsRef = Database.database().reference().child("posts").child(uid)
        
        userPostsRef.queryOrdered(byChild: "creation_date").observe(.childAdded, with: { (snapshot) in
            guard let values = snapshot.value, let dictionary = values as? [String: Any] else {
                completion(nil, DataError.errorUnwrappingDictionary(""))
                return
            }
            
            let post = Post(user: user, valuesDict: dictionary)
            
            
            completion(post, nil)
            
        }) { (error) in
            print(error)
            completion(nil, FirebaseDatabaseError.errorFetchingUserPosts(""))
        }
    } // fetchUserPosts
    
    func fetchListOfUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let usersRef = Database.database().reference().child("users")
        var users = [User]()
        
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value, let dictionaries = values as? [String: Any] else {
                completion(nil, DataError.errorUnwrappingDictionary(""))
                return
            }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {
                    completion(nil, DataError.errorUnwrappingDictionary(""))
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
            print("DEBUG ERROR: /// \(error)")
            completion(nil, FirebaseDatabaseError.errorFetchingListOfUsers(""))
        }
        
    } // fetchListOfUsers
    
    // MARK: - Save Post Functions

    func savePostToFirebase(postImage: UIImage, values: [String: Any], completion: @escaping (Error?) -> Void) {

        self.savePostImageToStorage(image: postImage) { (downloadURL, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }

            // attempt to save user info
            guard let downloadURL = downloadURL else {
                completion(FirebaseStorageError.errorFetchingImageDownloadURL(""))
                return
            }

            let uid = FirebaseAPI.shared.getCurrentUserUID()
            
            var valuesDict = values
            valuesDict["post_image_url"] = downloadURL

            Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(valuesDict) { (error, reference) in
                if let error = error {
                    print("error attempting to save post info to user: \(error)")
                    completion(FirebaseDatabaseError.errorSavingUserPostDetails(""))
                    return
                }

                print("successfully saved post information to user")
                completion(nil)
            }
        } // savePostImageToStorage

    } // savePostToFirebase

    // MARK: Save Posts Helper

    fileprivate func savePostImageToStorage(image: UIImage, completion: @escaping (String?, Error?) -> Void) {

        let fileName = NSUUID().uuidString
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {
            completion(nil, DataError.errorConvertingImage(""))
            return
        }

        let postsRef = Storage.storage().reference().child("post_images/\(fileName)")
        postsRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG ERROR: /// \(error)")
                completion(nil, FirebaseStorageError.errorSavingPost(""))
                return
            }

            postsRef.downloadURL(completion: { (downloadURL, error) in
                if let error = error {
                    print("DEBUG ERROR: /// \(error)")
                    completion(nil, FirebaseStorageError.errorFetchingImageDownloadURL(""))
                    return
                }

                guard let downloadURL = downloadURL else {
                    completion(nil, DataError.errorUnwrappingDownloadURL(""))
                    return
                }

                print("successfully fetched download URL: \(downloadURL.absoluteString)")
                completion(downloadURL.absoluteString, nil)
            }) // downloadURL
        } // putData

    } // savePostImageToStorage

    // MARK: Following/Unfollowing Functions

    func fetchFollowingListForCurrentUser(completion: @escaping ([String]?, Error?) -> Void) {
        let currentUUID = FirebaseAPI.shared.getCurrentUserUID()
        let followingRef = Database.database().reference().child("following").child(currentUUID)
        var following = [String]()

        followingRef.observe(.value, with: { (snapshot) in
            guard let values = snapshot.value, let valuesDict = values as? [String: Any] else {
                completion(nil, DataError.errorUnwrappingDictionary(""))
                return
            }

            valuesDict.forEach({ (key, value) in
                following.append(key)
            })

            completion(following, nil)
        }) { (error) in
            print(error)
            completion(nil, FirebaseDatabaseError.errorFetchingListOfUsers(""))
        }
    }

    func followUserWithUID(_ uidToFollow: String, completion: @escaping (Error?) -> Void) {
        let currentUUID = FirebaseAPI.shared.getCurrentUserUID()
        let followingRef = Database.database().reference().child("following").child(currentUUID)
        let values = [uidToFollow: true] as [String: Any]

        followingRef.updateChildValues(values) { (error, database) in
            if let error = error {
                print("DEBUG ERROR: /// \(error)")
                completion(FirebaseDatabaseError.errorFollowingUser("uidToFollow: \(uidToFollow)"))
                return
            }

            completion(nil)
        }
    }

    func unfollowUserWithUID(_ uidToUnfollow: String, completion: @escaping (Error?) -> Void) {
        let currentUUID = FirebaseAPI.shared.getCurrentUserUID()
        let followingRef = Database.database().reference().child("following").child(currentUUID)

        followingRef.child(uidToUnfollow).removeValue { (error, database) in
            if let error = error {
                print("DEBUG ERROR: /// \(error)")
                completion(FirebaseDatabaseError.errorUnfollowingUser("uidToUnfollow: \(uidToUnfollow)"))
                return
            }

            completion(nil)
        }
    }

} // FirebaseAPI
