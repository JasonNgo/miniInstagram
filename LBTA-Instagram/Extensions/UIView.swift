//
//  UIView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat,
                right: NSLayoutXAxisAnchor?, paddingRight: CGFloat,
                bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat,
                left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat,
                width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    } // anchor()
    
    func center(X: NSLayoutXAxisAnchor?, paddingCenterX: CGFloat,
                Y: NSLayoutYAxisAnchor?, paddingCenterY: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let X = X {
            self.centerXAnchor.constraint(equalTo: X, constant: paddingCenterX).isActive = true
        }
        
        if let Y = Y {
            self.centerYAnchor.constraint(equalTo: Y, constant: paddingCenterY).isActive = true
        }
        
    } // center()
    
    
} // UIView+Extension
