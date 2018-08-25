//
//  UIImageView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-24.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImageFromUrl(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        lastUrlUsedToLoadImage = urlString
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check for errors
            if let error = error {
                print("error attempting to fetch image: \(error)")
                return
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage { return }
            
            // check the response
            guard let response = response else { return }
            guard let responseHTTP = response as? HTTPURLResponse else { return }
            print("status code: \(responseHTTP.statusCode)")
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
        
    }
    
} // CustomImageView
