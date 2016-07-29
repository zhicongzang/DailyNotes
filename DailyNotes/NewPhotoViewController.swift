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
        
        saveButton.enabled = false
        
        
        
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
        if let captureDevice = devices.first as? AVCaptureDevice {
            do {
                try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                captureSession.sessionPreset = AVCaptureSessionPresetPhoto
                captureSession.startRunning()
                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                if captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addOutput(stillImageOutput)
                }
                if let realTimeLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                    realTimeLayer.frame = CGRect(x: 0, y: 0, width: cameraRealTimeView.frame.width, height: cameraRealTimeView.frame.height)
                    realTimeLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    cameraRealTimeView.layer.addSublayer(realTimeLayer)
                    cameraRealTimeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewPhotoViewController.takePhoto(_:))))
                }
                
                
            } catch {}
            
        }
    }
    
    @objc func takePhoto(sender: UIGestureRecognizer) {
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
        let actionDeleteDraft = UIAlertAction(title: "Delete Draft", style: UIAlertActionStyle.Destructive) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let actionSaveDraft = UIAlertAction(title: "Save Draft", style: UIAlertActionStyle.Default) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
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
        let photoLayer = CALayer()
        photoLayer.frame = CGRect(x: 0, y: 0, width: cell.frame.height, height: cell.frame.width)
        photoLayer.contents = (photo.CGImage)
        photoLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI_2)))
        cell.contentView.layer.addSublayer(photoLayer)
        return cell
    }
    
    
}





