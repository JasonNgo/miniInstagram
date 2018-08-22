//
//  FirebaseAPI.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import Firebase
import UIKit

class FirebaseAPI {
    
    static let shared = FirebaseAPI()
    
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    let auth = Auth.auth()
    
    func createUserWith(username: String, email: String, password: String, image: UIImage, completionHandler: @escaping () -> Void) {
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                print("error attempting to create user with username: \(username), email: \(email): \(err.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else { return }
            print("successfully created new user with uid: \(user.uid)")
            
            // attempt to save username to uid node
            let valuesDictionary = ["username": username]
            let values = [user.uid: valuesDictionary]
            
            self.databaseRef.child("users").updateChildValues(values, withCompletionBlock: { error, user in
                if let err = error {
                    print("error attempting to save the user uid to the database: \(err)")
                    return
                }
                
                print("successfully saved user's username into the db")
                self.uploadProfileImageToStorage(image: image)
            }) // updateChildValues
        } // createUser
    } // createUserWith(username:email:password;image:)
    
    func fetchUserWith(uid: String, completionHandler: @escaping (DataSnapshot) -> Void) {
        databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(snapshot)
        }) { (error) in
            print("error attempting to fetch user with uid: \(uid)")
        }
    } // fetchUserWith(uid:completionHandler:)
    
    // MARK: Helper Functions
    
    fileprivate func uploadProfileImageToStorage(image: UIImage) {
        let fileName = NSUUID().uuidString
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        let profileImagesRef = FirebaseAPI.shared.storageRef.child("profile_images/\(fileName)")

        let _ = profileImagesRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if let err = error {
                print("error attempting to upload image to Storage: \(err)")
                return
            }

            guard metadata != nil else { return }
            print("successfully uploaded image to Storage")
        }).observe(.success, handler: { (snapshot) in
            self.saveDownloadURL(snapshot: snapshot)
        }) // putData
    } // uploadProfileImageToStorage(image:)
    
    fileprivate func saveDownloadURL(snapshot: StorageTaskSnapshot) {
        guard let uid = FirebaseAPI.shared.auth.currentUser?.uid else { return }
        
        snapshot.reference.downloadURL(completion: { (url, error) in
            if let err = error {
                print("error attempting to fetch downloadURL: \(err)")
                return
            }
            
            guard let url = url else { return }
            print("successfully saved profile image to Storage with url: \(url.absoluteString)")
            
            // attempt to add newly created user to the database
            let values = ["profile_image_url": url.absoluteString]
            
            self.databaseRef.child("users").child(uid).updateChildValues(values, withCompletionBlock: { error, user in
                if let err = error {
                    print("error attempting to save the user uid to the database: \(err)")
                    return
                }
                
                print("successfully saved user into the db")
            }) // updateChildValues
        }) // downloadURL
    } // fetchDownloadURL(snapshot:)
    
} // FirebaseAPI
