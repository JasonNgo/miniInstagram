//
//  CameraController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-02.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraController: UIViewController {
  
  // MARK: - Views
  
  private let cameraHUDView = CameraHUDView()
  private var previewImageContainerView: PreviewImageContainerView?
  
  // MARK: - Properties
  
  let output = AVCapturePhotoOutput()
  let customAnimationPresentor = CustomAnimationPresentor()
  let customAnimationDismisser = CustomAnimationDismisser()
  
  // MARK: - Override functions
  
  override var prefersStatusBarHidden: Bool { return true }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    transitioningDelegate = self
    setupCaptureSession()
    setupHUD()
  }
  
  // MARK: - Set Up Functions
  
  fileprivate func setupCaptureSession() {
    let captureSession = AVCaptureSession()
    guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
    
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      if captureSession.canAddInput(input) {
        captureSession.addInput(input)
      }
    } catch let error {
      print("couldn't set up camera properly: ", error)
    }
    
    if captureSession.canAddOutput(output) {
      captureSession.addOutput(output)
    }
    
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)
    captureSession.startRunning()
  }
  
  fileprivate func setupHUD() {
    view.addSubview(cameraHUDView)
    cameraHUDView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
      right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0,
      left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
      width: 0, height: 0
    )
    
    cameraHUDView.dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    cameraHUDView.capturePhotoButton.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
  }
  
  // MARK: - CameraHUDView Selectors
  
  @objc func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleCapturePhoto() {
    print("capture photo pressed")
    
    let settings = AVCapturePhotoSettings()
    guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
    settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
    output.capturePhoto(with: settings, delegate: self)
  }
  
  // MARK: - PreviewImageContainerView Selectors
  
  @objc func handleCancelPhoto() {
    print("cancel photo pressed")
    previewImageContainerView?.removePreviewFromSuperview()
  }
  
  @objc func handleSavePhoto() {
    print("save photo pressed")

    guard let previewImage = previewImageContainerView?.previewImage else { return }
    let library = PHPhotoLibrary.shared()

    library.performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
    }) { (success, error) in
      if let error = error {
        print("failed to save image to photo library: \(String(describing: error))")
        return
      }

      print("successfully saved image to library")
      DispatchQueue.main.async {
        self.previewImageContainerView?.displaySaveMessage()
      }
    }
  }
  
}

// MARK: - AVCaptureDelegate

extension CameraController: AVCapturePhotoCaptureDelegate {
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard error == nil else {
      print("failed to capture photo: \(String(describing: error))")
      return
    }
    
    guard let imageData = photo.fileDataRepresentation(),
      let previewImage = UIImage.init(data: imageData, scale: 1.0) else {
        return
    }
    
    let containerView = PreviewImageContainerView()
    containerView.cancelPhotoButton.addTarget(self, action: #selector(handleCancelPhoto), for: .touchUpInside)
    containerView.savePhotoButton.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
    containerView.previewImage = previewImage
    
    view.addSubview(containerView)
    containerView.anchor(
      top: view.topAnchor, paddingTop: 0,
      right: view.rightAnchor, paddingRight: 0,
      bottom: view.bottomAnchor, paddingBottom: 0,
      left: view.leftAnchor, paddingLeft: 0,
      width: 0, height: 0
    )
  }
  
}

// MARK: - UIViewControllerTransitioningDelegate

extension CameraController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return customAnimationPresentor
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return customAnimationDismisser
  }
  
}
