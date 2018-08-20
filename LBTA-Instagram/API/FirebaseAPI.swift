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

    func createUserWith(username: String, email: String, password: String, image: UIImage,
                        completionHandler: @escaping () -> Void) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            
            if let err = error {
                print("error attempting to create user with username: \(username), email: \(email): \(err.localizedDescription)")
                return
            }

            guard let user = authResult?.user else { return }
            print("successfully created new user with uid: \(user.uid)")

            // add image to the Firebase Storage
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            self.storageRef.child("profile_image").putData(uploadData, metadata: nil, completion: { storageMetadata, error in
                
                if let err = error {
                    print("error attempting to save image to Storage: \(err.localizedDescription)")
                    return
                }

                guard let profileImageUrl = storageMetadata?.path else { return }

                // attempt to add newly created user to the database
                let valuesDictionary = [
                    "username": username,
                    "profile_image_url": profileImageUrl
                ]

                let values = [user.uid: valuesDictionary]
                self.databaseRef.child("users").updateChildValues(values, withCompletionBlock: { error, user in
                    
                    if let err = error {
                        print("error attempting to save the user uid to the database: \(err.localizedDescription)")
                        return
                    }

                    print("successfully saved user into the db")
                    
                }) // updateChildValues
                
            }) // putData
            
        } // createUser
        
    } // createUserWith(username:email:password;image:)

} // FirebaseAPI
