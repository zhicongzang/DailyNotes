//
//  NewPhotoViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/28/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class NewPhotoViewController: UIViewController {
    
    @IBOutlet weak var shutterButtonLC: NSLayoutConstraint!
    @IBOutlet weak var cameraRealTimeView: UIView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var _assetCollection:PHAssetCollection?
    
    private var assetCollection:PHAssetCollection {
        get {
            if _assetCollection == nil {
                _assetCollection = Utils.getAssetCollection(title: AssetCollectionTitle)
            }
            return _assetCollection!
        }
    }
    
    var photos = [UIImage]() {
        didSet {
            if photos.count > 0 {
                saveButton.enabled = true
            } else {
                saveButton.enabled = false
            }
            photosCollectionView.reloadData()
        }
    }
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    let realTimeLayer = AVCaptureVideoPreviewLayer()
    var deviceInput = AVCaptureDeviceInput()
    
    private var _focusSquare: UIView?
    var focusSquare: UIView {
        get {
            if _focusSquare == nil {
                _focusSquare = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                _focusSquare!.layer.borderColor = UIColor.orangeColor().CGColor
                _focusSquare!.layer.borderWidth = 1
                self.cameraRealTimeView.addSubview(_focusSquare!)
            }
            return _focusSquare!
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        shutterButtonLC.constant = self.view.frame.height * 0.01
        
        saveButton.enabled = false
        
        
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
        if let captureDevice = devices.first as? AVCaptureDevice {
            do {
                try deviceInput = AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(deviceInput)
                captureSession.sessionPreset = AVCaptureSessionPresetPhoto
                captureSession.startRunning()
                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                if captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addOutput(stillImageOutput)
                }
                realTimeLayer.session = captureSession
                realTimeLayer.frame = CGRect(x: 0, y: 0, width: cameraRealTimeView.frame.width, height: cameraRealTimeView.frame.height)
                realTimeLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                cameraRealTimeView.layer.addSublayer(realTimeLayer)
                let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(NewPhotoViewController.singleTap(_:)))
                singleTapGesture.numberOfTapsRequired = 1
                singleTapGesture.delaysTouchesBegan = true
                self.cameraRealTimeView.addGestureRecognizer(singleTapGesture)
                
                
            } catch {}
            
        }
    }
    
    func changeDevicePropertySafety(propertyChange: (AVCaptureDevice) -> Void) {
        let device = deviceInput.device
        do {
            try device.lockForConfiguration()
            captureSession.beginConfiguration()
            propertyChange(device)
            device.unlockForConfiguration()
            captureSession.commitConfiguration()
        } catch {}
    }
    
    func setFocusCursorAnimationWithPoint(point: CGPoint) {
        self.cameraRealTimeView.bringSubviewToFront(focusSquare)
        self.focusSquare.center = point
        self.focusSquare.transform = CGAffineTransformIdentity
        self.focusSquare.alpha = 1.0
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.focusSquare.transform=CGAffineTransformMakeScale(0.8, 0.8)
            self.focusSquare.alpha = 0.0
            }, completion: nil)
    }
    
    @objc func singleTap(tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.locationInView(self.cameraRealTimeView)
        let cameraPoint = realTimeLayer.captureDevicePointOfInterestForPoint(point)
        setFocusCursorAnimationWithPoint(point)
        
        changeDevicePropertySafety({ (device) in
            if device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) {
                device.focusMode = .AutoFocus
            }
            if device.focusPointOfInterestSupported {
                device.focusPointOfInterest = cameraPoint
            }
            if device.isExposureModeSupported(AVCaptureExposureMode.AutoExpose) {
                device.exposureMode = .AutoExpose
                
            }
            if device.exposurePointOfInterestSupported {
                device.exposurePointOfInterest = cameraPoint
            }
            if device.isFocusModeSupported(AVCaptureFocusMode.ContinuousAutoFocus) {
                device.focusMode = .ContinuousAutoFocus
            }
            if device.isExposureModeSupported(AVCaptureExposureMode.ContinuousAutoExposure) {
                device.exposureMode = .ContinuousAutoExposure
            }
        })
        
    }
    
    @IBAction func shutterButtonPressed(sender: AnyObject) {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                if let image = UIImage(data: imageData) {
                    self.photos.append(image)
                }
            }
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        Utils.savePhotos(assetCollection: assetCollection, photos: photos, completed: {
            self.dismissViewControllerAnimated(true, completion: nil)
        }())
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionDeleteDraft = UIAlertAction(title: "Delete Photos", style: UIAlertActionStyle.Destructive) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let actionSaveDraft = UIAlertAction(title: "Save Photos", style: UIAlertActionStyle.Default) { (_) in
            Utils.savePhotos(assetCollection: self.assetCollection, photos: self.photos, completed: {
                self.dismissViewControllerAnimated(true, completion: nil)
                }())
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) in
            return
        }
        alert.addAction(actionDeleteDraft)
        alert.addAction(actionSaveDraft)
        alert.addAction(actionCancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    

}


extension NewPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        let photo = photos[indexPath.row]
        cell.contentView.layer.contents = photo.CGImage
        cell.contentView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI_2)))
        return cell
    }
    
    
}





