//
//  UIBarButtonItem.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-26.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

 import UIKit

extension UIBarButtonItem {
    func makeHidden() {
        self.tintColor = .clear
        self.isEnabled = false
    }
    
    func makeVisible() {
        self.tintColor = .blue
        self.isEnabled = true
    }
}
