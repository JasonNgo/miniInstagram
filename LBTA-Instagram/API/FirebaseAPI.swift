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

class FirebaseAPI {
    
    static let shared = FirebaseAPI()
    
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    let auth = Auth.auth()
    
    func getCurrentUserUID() -> String? {
        guard let currentUserUID = auth.currentUser?.uid else { return nil }
        return currentUserUID
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
    
    func loginUserWith(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { (dataResult, error) in
            
            if let err = error {
                print("error attempting to login email: \(email): \(err)")
                completionHandler(false)
                return
            }
            
            guard let _ = dataResult else { return }
            completionHandler(true)
        }
    }
    
    func logoutUser(completionHandler: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completionHandler(true)
        } catch let error {
            print("error attempting to logout: \(error)")
            completionHandler(false)
            return
        }
    }
    
    // MARK: - Database Functions
    
    func fetchUserWith(uid: String, completionHandler: @escaping (DataSnapshot) -> Void) {
        databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(snapshot)
        }) { (error) in
            print("error attempting to fetch user with uid: \(uid)")
        }
    }
    
} // FirebaseAPI
