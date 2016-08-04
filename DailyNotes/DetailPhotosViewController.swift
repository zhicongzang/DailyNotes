//
//  DetailPhotosViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/2/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class DetailPhotosViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var index = 0
    
    var parentVC: NewPhotoViewController!
    
    private var myContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
        self.photosCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "DetailCell")
        parentVC = parentViewController as! NewPhotoViewController
        navigationBar.topItem!.title = "\(index + 1) of \(parentVC.photos.count)"
        navigationBarDismiss(animated: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailPhotosViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let layout = photosCollectionView.collectionViewLayout as! DetailPhotosCollectionLayout
        layout.setIndex(index: index)
        layout.addObserver(self, forKeyPath: "index", options: NSKeyValueObservingOptions.New, context: &myContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeNewKey] {
                index = newValue as! Int
                navigationBar.topItem!.title = "\(index + 1) of \(parentVC.photos.count)"
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        (photosCollectionView.collectionViewLayout as! DetailPhotosCollectionLayout).removeObserver(self, forKeyPath: "index")
        parentVC.startCaptureSession()
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }

    func navigationBarDismiss(animated animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.3, animations: { 
                self.navigationBar.transform = CGAffineTransformMakeTranslation(0, -self.navigationBar.frame.height)
                self.navigationBar.alpha = 0
                }, completion: nil)
        } else {
            self.navigationBar.transform = CGAffineTransformMakeTranslation(0, -self.navigationBar.frame.height)
            self.navigationBar.alpha = 0
        }
    }
    
    func navigationBarAppear(animated animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.3, animations: {
                self.navigationBar.transform = CGAffineTransformIdentity
                self.navigationBar.alpha = 1
                }, completion: nil)
        } else {
            self.navigationBar.transform = CGAffineTransformIdentity
            self.navigationBar.alpha = 1
        }
    }
    
    @objc func tapGesture(tapGesture: UITapGestureRecognizer) {
        if navigationBar.alpha < 1 {
            navigationBarAppear(animated: true)
        } else {
            navigationBarDismiss(animated: true)
        }
    }

}

extension DetailPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentVC.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCollectionViewCell
        cell.delegate = self
        let photo = parentVC.photos[indexPath.row]
        cell.setImage(photo)
        return cell
    }
    
    
}

extension DetailPhotosViewController: DetailCollectionViewCellDelegate {
    
    private func nextCell() -> DetailCollectionViewCell? {
        let nextIndexPath = NSIndexPath(forItem: index + 1, inSection: 0)
        return self.photosCollectionView.cellForItemAtIndexPath(nextIndexPath) as? DetailCollectionViewCell
    }
    
    func moveBegin(cell: DetailCollectionViewCell) {
        return
    }
    
    func cell(cell: DetailCollectionViewCell, translated translation: CGPoint) {
        let layout = self.photosCollectionView.collectionViewLayout as! DetailPhotosCollectionLayout
        if let nextCell = self.nextCell() {
            let scale = max(min(0.9 + fabs(translation.y / layout.pageDistance) / 10.0 ,1.0),0.0)
            nextCell.transform = CGAffineTransformMakeScale(scale, scale)
            nextCell.alpha = max(min(fabs(translation.y / layout.pageDistance) ,1.0),0.0)
        }
    }
    
    func cell(cell: DetailCollectionViewCell, completedWithRemove remove: Bool) {
        let layout = self.photosCollectionView.collectionViewLayout as! DetailPhotosCollectionLayout
        if remove {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            parentVC.photos.removeAtIndex(index)
            self.photosCollectionView.deleteItemsAtIndexPaths([indexPath])
            layout.setIndex(index: min(index,parentVC.photos.count - 1))
        } else {
            if let nextCell = self.nextCell(){
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    nextCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
                    nextCell.alpha = 0
                })
            }
        }
    }
}
