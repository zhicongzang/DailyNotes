//
//  NewNoteDetailsViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 8/17/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import MapKit

class NewNoteDetailsViewController: UIViewController {
    
    
    var block: ((CLLocation, String?) -> Void)!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moveAnnotationImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let identifier = "annotation"
    
    var isLocked = true

    var location: CLLocation! {
        didSet {
            annotation.coordinate = location.coordinate
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                let name = placemarks?.first?.name
                if self.locationNameTextField != nil {
                    self.locationNameTextField.placeholder = name
                }
                if !self.isLocked && self.locationNameTextField.text?.removeHeadAndTailSpacePro == "" {
                    self.locationName = name
                }
            })
            
        }
    }
    
    var regionDistance = 5000.0
    
    
    var locationName: String? {
        didSet {
            self.annotation.subtitle = locationName
        }
    }
    
    let annotation = MKPointAnnotation()
    
    let geocoder: CLGeocoder = CLGeocoder()
    
    var createdDate: NSDate?
    var updateDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTextField.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        locationNameTextField.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        
        setupMapView()
        
        let tapGestureForMapView = UITapGestureRecognizer(target: self, action: #selector(NewNoteDetailsViewController.dismissKeyboard(_:)))
        tapGestureForMapView.cancelsTouchesInView = false
        let tapGestureForNavigationBar = UITapGestureRecognizer(target: self, action: #selector(NewNoteDetailsViewController.dismissKeyboard(_:)))
        tapGestureForNavigationBar.cancelsTouchesInView = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewNoteDetailsViewController.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        mapView.addGestureRecognizer(tapGestureForMapView)
        navigationBar.addGestureRecognizer(tapGestureForNavigationBar)
        self.view.addGestureRecognizer(tapGesture)
        
        if createdDate != nil {
            dateLabel.text = "Update: \(updateDate!.stringDaysToNow()), Created: \(createdDate!.stringDaysToNow())"
        }
        
        
    }
    
    @objc func dismissKeyboard(recognizer: UIGestureRecognizer) {
        locationNameTextField.resignFirstResponder()
        tagTextField.resignFirstResponder()
    }
    
    func setInformation(subject subject: String, location: CLLocation, locationName: String?, createdDate: NSDate?, updateDate: NSDate?) {
        annotation.title = subject
        self.location = location
        self.locationName = locationName
        self.annotation.subtitle = locationName
        self.createdDate = createdDate
        self.updateDate = updateDate
    }
    
    func setupMapView() {
        
        let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(location.coordinate, regionDistance, regionDistance))
        self.mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.zoomEnabled = false
        mapView.rotateEnabled = false
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(NewNoteDetailsViewController.handleDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        mapView.addGestureRecognizer(doubleTapGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(NewNoteDetailsViewController.handlePinchGesture(_:)))
        pinchGesture.delegate = self
        mapView.addGestureRecognizer(pinchGesture)
    }
    
    @objc
    func handleDoubleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        regionDistance = max(300, regionDistance / 2)
        let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(location.coordinate, regionDistance, regionDistance))
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc
    func handlePinchGesture(gestureRecognizer: UIPinchGestureRecognizer) {
        regionDistance = min(max(300, regionDistance / Double(gestureRecognizer.scale)), 10000000)
        let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(location.coordinate, regionDistance, regionDistance))
        self.mapView.setRegion(region, animated: false)
        gestureRecognizer.scale = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func locationNameTextFieldEditing(sender: AnyObject) {
        if let name = locationNameTextField.text?.removeHeadAndTailSpacePro where name != "" {
            locationName = name
        } else {
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                self.locationName = placemarks?.first?.name
            })
        }
    }
    
    @IBAction func textFieldDidEndOnExit(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    
    

    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        block(location, locationName)
        super.dismissViewControllerAnimated(flag, completion: completion)
    }

}

extension NewNoteDetailsViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        self.mapView.addAnnotation(annotation)
        isLocked = false
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            let name = placemarks?.first?.name
            if self.locationNameTextField != nil {
                self.locationNameTextField.placeholder = name
                if name != self.locationName {
                    self.locationNameTextField.text = self.locationName
                }
            }
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = UIImage(named: "MapPin")
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        views.forEach { (view) in
            if let annotation = view.annotation where annotation.isKindOfClass(MKUserLocation) {
                view.canShowCallout = false
            }
        }
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if let view = mapView.viewForAnnotation(annotation) {
            view.alpha = 0.5
        }
        moveAnnotationImageView.hidden = false
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !isLocked {
            self.location = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        }
        if let view = mapView.viewForAnnotation(annotation) {
            view.alpha = 1
        }
        moveAnnotationImageView.hidden = true
        
    }
    
}

extension NewNoteDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}