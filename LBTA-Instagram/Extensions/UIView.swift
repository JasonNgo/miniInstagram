//
//  UIView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-08-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

extension UIView {
  
  func anchor(
    top: NSLayoutYAxisAnchor?, paddingTop: CGFloat,
    right: NSLayoutXAxisAnchor?, paddingRight: CGFloat,
    bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat,
    left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat,
    width: CGFloat, height: CGFloat) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let left = left {
      leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
  
  func center(centerX: NSLayoutXAxisAnchor?, paddingCenterX: CGFloat, centerY: NSLayoutYAxisAnchor?, paddingCenterY: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    
    if let centerX = centerX {
      centerXAnchor.constraint(equalTo: centerX, constant: paddingCenterX).isActive = true
    }
    
    if let centerY = centerY {
      centerYAnchor.constraint(equalTo: centerY, constant: paddingCenterY).isActive = true
    }
  }
  
}
