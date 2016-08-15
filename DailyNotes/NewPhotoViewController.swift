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
    @IBOutlet weak var flashButton: FlashButton!
    @IBOutlet weak var changeCameraButton: UIButton!
    
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
    
    var beginGestureScale: CGFloat = 1.0
    var effectiveScale: CGFloat = 1.0
    
    lazy var imageContext: CIContext = {
        return CIContext(options: nil)
    }()
    
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        //self.photosCollectionView.registerClass(NewPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
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
                realTimeLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.75)
                realTimeLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                cameraRealTimeView.layer.addSublayer(realTimeLayer)
                let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(NewPhotoViewController.singleTap(_:)))
                singleTapGesture.numberOfTapsRequired = 1
                singleTapGesture.delaysTouchesBegan = true
                self.cameraRealTimeView.addGestureRecognizer(singleTapGesture)
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(NewPhotoViewController.pinchGesture(_:)))
                self.cameraRealTimeView.addGestureRecognizer(pinchGesture)
                
            } catch {}
            
        }
        
        self.cameraRealTimeView.bringSubviewToFront(flashButton)
        self.changeCameraButton.setBorder()
        self.cameraRealTimeView.bringSubviewToFront(changeCameraButton)
    }
    
    @objc func singleTap(tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.locationInView(self.cameraRealTimeView)
        let cameraPoint = realTimeLayer.captureDevicePointOfInterestForPoint(point)
        setFocusCursorAnimationWithPoint(point)
        setFocusAndExposurePoint(cameraPoint)
    }
    
    @objc func pinchGesture(pinchGesture: UIPinchGestureRecognizer) {
        self.effectiveScale = min(max(self.beginGestureScale * pinchGesture.scale, 1.0), self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo).videoMaxScaleAndCropFactor)
        changeZoom(effectiveScale)
    }
    
    @IBAction func shutterButtonPressed(sender: AnyObject) {
        takePhoto()
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
    
    @IBAction func flashButtonPressed(sender: AnyObject) {
        let s = sender as! FlashButton
        s.changeFlashMode()
        self.setFlashMode(s.flashMode)
    }

    @IBAction func changeCameraButtonPressed(sender: AnyObject) {
        self.changeCamera()
    }
}

extension NewPhotoViewController {
    private func changeDevicePropertySafety(propertyChange: (AVCaptureDevice) -> Void) {
        let device = deviceInput.device
        do {
            try device.lockForConfiguration()
            captureSession.beginConfiguration()
            propertyChange(device)
            device.unlockForConfiguration()
            captureSession.commitConfiguration()
        } catch {}
    }
    
    private func setFocusCursorAnimationWithPoint(point: CGPoint) {
        self.cameraRealTimeView.bringSubviewToFront(focusSquare)
        self.focusSquare.center = point
        self.focusSquare.transform = CGAffineTransformIdentity
        self.focusSquare.alpha = 1.0
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.focusSquare.transform=CGAffineTransformMakeScale(0.8, 0.8)
            self.focusSquare.alpha = 0.0
            }, completion: nil)
    }
    
    private func takePhoto() {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoScaleAndCropFactor = self.effectiveScale
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                if let image = self.getImageWithAutoAdjest(imageData) {
                    self.photos.append(image)
                }
            }
        }
    }
    
    private func setFocusPoint(device: AVCaptureDevice, cameraPoint: CGPoint) {
        if device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) {
            device.focusMode = .AutoFocus
        }
        if device.focusPointOfInterestSupported {
            device.focusPointOfInterest = cameraPoint
        }
        if device.isFocusModeSupported(AVCaptureFocusMode.ContinuousAutoFocus) {
            device.focusMode = .ContinuousAutoFocus
        }
    }
    
    private func setExposurePoint(device: AVCaptureDevice, cameraPoint: CGPoint) {
        if device.isExposureModeSupported(AVCaptureExposureMode.AutoExpose) {
            device.exposureMode = .AutoExpose
        }
        if device.exposurePointOfInterestSupported {
            device.exposurePointOfInterest = cameraPoint
        }
        if device.isExposureModeSupported(AVCaptureExposureMode.ContinuousAutoExposure) {
            device.exposureMode = .ContinuousAutoExposure
        }
    }
    
    private func setFocusAndExposurePoint(cameraPoint: CGPoint) {
        changeDevicePropertySafety({ (device) in
            self.setFocusPoint(device, cameraPoint: cameraPoint)
            self.setExposurePoint(device, cameraPoint: cameraPoint)
            
        })
    }
    
    private func setFlashMode(flashMode: FlashMode) {
        changeDevicePropertySafety { (device) in
            if device.hasFlash {
                switch flashMode {
                case .Auto:
                    if device.isFlashModeSupported(AVCaptureFlashMode.Auto) {
                        device.flashMode = .Auto
                    }
                    if device.hasTorch && device.torchMode == .On{
                        device.torchMode = .Off
                    }
                case .On:
                    if device.isFlashModeSupported(AVCaptureFlashMode.On) {
                        device.flashMode = .On
                    }
                    if device.hasTorch && device.torchMode != .On{
                        device.torchMode = .On
                    }
                case .Off:
                    if device.isFlashModeSupported(AVCaptureFlashMode.Off) {
                        device.flashMode = .Off
                    }
                    if device.hasTorch && device.torchMode == .On{
                        device.torchMode = .Off
                    }
                }
            }
        }
    }
    
    private func deviceWithType(preferringPosition preferringPosition: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) } as! [AVCaptureDevice]
        var device = devices.first!
        for d in devices {
            if d.position == preferringPosition {
                device = d
                break
            }
        }
        return device
        
    }
    
    private func changeCamera() {
        changeDevicePropertySafety { (device) in
            switch device.position {
            case .Back:
                do {
                    let newDevice = self.deviceWithType(preferringPosition: AVCaptureDevicePosition.Front)
                    let newDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.removeInput(self.deviceInput)
                    if self.captureSession.canAddInput(newDeviceInput) {
                        self.deviceInput = newDeviceInput
                    }
                    self.captureSession.addInput(self.deviceInput)
                } catch {}
            case .Front:
                do {
                    let newDevice = self.deviceWithType(preferringPosition: AVCaptureDevicePosition.Back)
                    let newDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.removeInput(self.deviceInput)
                    if self.captureSession.canAddInput(newDeviceInput) {
                        self.deviceInput = newDeviceInput
                    }
                    self.captureSession.addInput(self.deviceInput)
                } catch {}
            default:
                return
            }
        }
    }
    
    private func changeZoom(scale: CGFloat) {
        changeDevicePropertySafety { (device) in
            device.rampToVideoZoomFactor(scale, withRate: 50)
        }
    }
    
    private func getImageWithAutoAdjest(data: NSData) -> UIImage? {
        var inputImage = CIImage(data: data)
        guard inputImage != nil else {
            return nil
        }
        let filters = inputImage!.autoAdjustmentFiltersWithOptions(nil) as [CIFilter]
        for filter in filters {
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            inputImage = filter.outputImage!
        }
        let cgImage = imageContext.createCGImage(inputImage!, fromRect: inputImage!.extent)
        return UIImage(CGImage: cgImage, scale: 1.0, orientation: UIImageOrientation.Right)
    }
    
    func startCaptureSession() {
        captureSession.startRunning()
        setFlashMode(flashButton.flashMode)
    }
    
    func stopCaptureSession() {
        captureSession.stopRunning()
    }
}


extension NewPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.imgView.image = photo
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = self.photosCollectionView.frame.height - 10
        let photoSize = photos[indexPath.row].size
        let width = height * photoSize.width / photoSize.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailPhotosVC = storyboard?.instantiateViewControllerWithIdentifier("DetailPhotos") as! DetailPhotosViewController
        detailPhotosVC.index = indexPath.row
        stopCaptureSession()
        self.configureChildViewController(childController: detailPhotosVC, onView: self.view, constraints: .Constraints(top: 0, buttom: 0, left: 0, right: 0))
    }
    
    
}

extension NewPhotoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let sender = touch.view where sender.isKindOfClass(UIButton) {
            return false
        }
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPinchGestureRecognizer) {
            self.beginGestureScale = self.effectiveScale
        }
        return true
    }
    
}






