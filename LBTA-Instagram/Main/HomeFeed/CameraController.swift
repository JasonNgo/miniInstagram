//
//  CameraController.swift
//  LBTA-Instagram
//
//  Created by Jason Ngo on 2018-09-02.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let output = AVCapturePhotoOutput()
    
    // MARK: - Views and Selectors
    
    let dismissButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCapturePhoto() {
        print("capture photo pressed")
        
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("failed to capture photo: \(String(describing: error))")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage.init(data: imageData, scale: 1.0) else { return }
        
        let previewImage = UIImageView(image: image)
        view.addSubview(previewImage)
        previewImage.anchor(top: view.topAnchor, paddingTop: 0, right: view.rightAnchor, paddingRight: 0,
                            bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0,
                            width: 0, height: 0)
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
    }
    
    
    let cancelPhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancelPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancelPhoto() {
        print("cancel photo pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Sets the status bar to hidden when the view has finished appearing
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Sets the status bar to visible when the view is about to disappear
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.isHidden = false
        }
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // setup input
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("couldn't set up camera properly: ", error)
        }
        
        // setup output
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        // setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.center(centerX: view.centerXAnchor, paddingCenterX: 0, centerY: nil, paddingCenterY: 0)
        capturePhotoButton.anchor(top: nil, paddingTop: 0, right: nil, paddingRight: 0,
                                  bottom: view.bottomAnchor, paddingBottom: -24, left: nil, paddingLeft: 0,
                                  width: 80, height: 80)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, paddingTop: 12, right: view.rightAnchor, paddingRight: -12,
                             bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0,
                             width: 50, height: 50)
        
        view.addSubview(cancelPhotoButton)
        cancelPhotoButton.anchor(top: view.topAnchor, paddingTop: 12, right: nil, paddingRight: 0,
                                 bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 12,
                                 width: 50, height: 50)
    }

} // CameraController
