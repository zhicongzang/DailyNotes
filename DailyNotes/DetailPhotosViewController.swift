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
    
    var photos = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.photosCollectionView.registerClass(DetailPhotosCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DetailCell", forIndexPath: indexPath) as! DetailPhotosCollectionViewCell
        cell.delegate = self
        let photo = photos[indexPath.row]
        cell.setupImage(photo)
        return cell
    }
}

extension DetailPhotosViewController: DetailPhotosCollectionViewCellDelegate {
    
    private func nextCell() -> DetailPhotosCollectionViewCell? {
        let layout = self.photosCollectionView.collectionViewLayout as! DetailPhotosCollectionLayout
        let cardIndex = Int(floor(self.photosCollectionView.contentOffset.x / layout.pageDistance))
        let nextIndexPath = NSIndexPath(forItem: cardIndex + 1, inSection: 0)
        return self.photosCollectionView.cellForItemAtIndexPath(nextIndexPath) as? DetailPhotosCollectionViewCell
    }
    
    func moveBegin(cell: DetailPhotosCollectionViewCell) {
        return
    }
    
    func cell(cell: DetailPhotosCollectionViewCell, translated translation: CGPoint) {
        let layout = self.photosCollectionView.collectionViewLayout as! DetailPhotosCollectionLayout
        if let nextCell = self.nextCell() {
            let scale = max(min(0.9 + fabs(translation.y / layout.pageDistance) / 10.0 ,1.0),0.0)
            nextCell.transform = CGAffineTransformMakeScale(scale, scale)
            
        }
    }
    
    func cell(cell: DetailPhotosCollectionViewCell, completedWithRemove remove: Bool) {
        let layout = self.photosCollectionView.collectionViewLayout as! DetailPhotosCollectionLayout
        if remove {
            let cardIndex = Int(floor(self.photosCollectionView.contentOffset.x / layout.pageDistance))
            let indexPath = NSIndexPath(forItem: cardIndex, inSection: 0)
            self.photos.removeAtIndex(cardIndex)
            self.photosCollectionView.deleteItemsAtIndexPaths([indexPath])
        } else {
            if let nextCell = self.nextCell(){
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    nextCell.transform = CGAffineTransformMakeScale(0.9, 0.9)
                })
            }
        }
    }
}
