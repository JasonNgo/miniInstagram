//
//  CameraHUDView.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-12-08.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CameraHUDView: UIView {
  
  let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    let image = #imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal)
    button.setImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let capturePhotoButton: UIButton = {
    let button = UIButton(type: .system)
    let image = #imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal)
    button.setImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    createDismissButtonSubview()
    createPhotoCaptureSubview()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func createDismissButtonSubview() {
    addSubview(dismissButton)
    dismissButton.anchor(
      top: topAnchor, paddingTop: 12,
      right: rightAnchor, paddingRight: 12,
      bottom: nil, paddingBottom: 0,
      left: nil, paddingLeft: 0,
      width: 50, height: 50
    )
  }
  
  fileprivate func createPhotoCaptureSubview() {
    addSubview(capturePhotoButton)
    capturePhotoButton.center(
      centerX: centerXAnchor, paddingCenterX: 0,
      centerY: nil, paddingCenterY: 0
    )
    capturePhotoButton.anchor(
      top: nil, paddingTop: 0,
      right: nil, paddingRight: 0,
      bottom: bottomAnchor, paddingBottom: 24,
      left: nil, paddingLeft: 0,
      width: 80, height: 80
    )
  }
  
}
