//
//  RootViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/20/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import Photos

class RootViewController: UIViewController {
    
    @IBOutlet weak var noteButton: RootButton!
    @IBOutlet weak var photoButton: RootButton!
    @IBOutlet weak var reminderButton: RootButton!
    @IBOutlet weak var listButton: RootButton!
    @IBOutlet weak var audioButton: RootButton!
    
    @IBOutlet weak var searchingButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    @IBOutlet var buttonPaddings: [NSLayoutConstraint]!
    @IBOutlet weak var buttonsToTopLayoutConstraint: NSLayoutConstraint!
    
    let imagePickerController = UIImagePickerController()
    
//    private var _assetCollection:PHAssetCollection?
//    
//    private var assetCollection:PHAssetCollection {
//        get {
//            if _assetCollection == nil {
//                _assetCollection = Utils.getAssetCollection(title: AssetCollectionTitle)
//            }
//            return _assetCollection!
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
//        setupImagePickerController()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupButtons() {
        buttonsToTopLayoutConstraint.constant = rootButtonWidth / 2
        buttonPaddings.forEach { (buttonPadding) in
            buttonPadding.constant = rootButtonWidth
        }
        searchingButton.frame.size = CGSize(width: rootButtonWidth / 2, height: rootButtonWidth / 2)
        settingsButton.frame.size = CGSize(width: rootButtonWidth / 2, height: rootButtonWidth / 2)
    }
    
    @IBAction func reminderButtonPressed(sender: AnyObject) {
        let newReminderNC = storyboard?.instantiateViewControllerWithIdentifier("NewReminder") as! NewReminderViewController
        self.configureChildViewController(childController: newReminderNC, onView: self.view, constraints: .Constraints(top: -44, buttom: 0, left: 0, right: 0))
    }
    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
}

//extension RootViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func setupImagePickerController() {
//        imagePickerController.delegate = self
//        imagePickerController.modalTransitionStyle = .FlipHorizontal
//        imagePickerController.allowsEditing = false
//        imagePickerController.sourceType = .Camera
//        imagePickerController.videoMaximumDuration = 60
//        imagePickerController.mediaTypes = ["public.image","public.movie"]
//        imagePickerController.videoQuality = .TypeHigh
//        imagePickerController.cameraCaptureMode = .Photo
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        let mediaType = info[UIImagePickerControllerMediaType] as! String
//        let aCollection = self.assetCollection
//        if mediaType == "public.image" {
//            let image = info[UIImagePickerControllerOriginalImage] as!UIImage
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                PHPhotoLibrary.sharedPhotoLibrary().performChanges({ 
//                    let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
//                    let assetPlaceHolder = assetRequest.placeholderForCreatedAsset
//                    let photoAsset = PHAsset.fetchAssetsInAssetCollection(aCollection, options: nil)
//                    if let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: aCollection, assets: photoAsset) {
//                        albumChangeRequest.addAssets([assetPlaceHolder!])
//                    }
//                    }, completionHandler: { (success, error) in
//                        dispatch_async(dispatch_get_main_queue(), { 
//                            if !success {
//                                UIImageWriteToSavedPhotosAlbum(image, self, #selector(RootViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
//                            }
//                        })
//
//                })
//            })
//            
//        } else {
//            let urlStr = (info[UIImagePickerControllerMediaURL] as! NSURL).path!
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, #selector(RootViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
//            })
//        }
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
//        if error == nil {
//            let ac = UIAlertController(title: "Saved!", message: "成功保存照片到图库", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        } else {
//            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        }
//    }
//    
//    func video(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
//        if error == nil {
//            let ac = UIAlertController(title: "Saved!", message: "成功保存视频到图库", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        } else {
//            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        }
//    }
//}



