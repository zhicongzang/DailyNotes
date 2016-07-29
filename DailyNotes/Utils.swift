//
//  Utils.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/28/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

class Utils {
    class func getAssetCollection(title title: String) -> PHAssetCollection {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", title)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        if let _assetCollection = collection.firstObject as? PHAssetCollection {
            return _assetCollection
        }
        var _assetCollection = PHAssetCollection()
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(title)
            createAlbumRequest.placeholderForCreatedAssetCollection
        }) { (success, error) in
            if (!success) {
                NSLog("Error creating album: \(error)")
            } else {
                _assetCollection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions).firstObject as! PHAssetCollection
            }
        }
        return _assetCollection
    }
    
    class func createAssetCollection(title title: String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", title)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        guard let _ = collection.firstObject as? PHAssetCollection else {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(title)
                createAlbumRequest.placeholderForCreatedAssetCollection
            }) { (success, error) in
                if (!success) {
                    NSLog("Error creating album: \(error)")
                }
            }
            return
        }
    }
    
    class func getCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case AVAuthorizationStatus.NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: nil)
        default:
            break
        }
    }
    
    class func savePhotos(assetCollection assetCollection: PHAssetCollection, photos: [UIImage], completed: Void?) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            var assetPlaceHolders = [PHObjectPlaceholder]()
            photos.forEach({ (photo) in
                let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(photo)
                if let placeHolder = assetRequest.placeholderForCreatedAsset {
                    assetPlaceHolders.append(placeHolder)
                }
            })
            let photoAsset = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
            if let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: assetCollection, assets: photoAsset) {
                albumChangeRequest.addAssets(assetPlaceHolders)
            }
            }) { (success, error) in
                if !success {
                    NSLog("Error saving photos: \(error)")
                } else {
                    completed
                }
        }
    }
    
    class func getPhotoLibraryAuthorization(handler handler: Void?) {
        if PHPhotoLibrary.authorizationStatus() != .Authorized {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .Authorized {
                    handler
                }
                
            })
        }
    }
}