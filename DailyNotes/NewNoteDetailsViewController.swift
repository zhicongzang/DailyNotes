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
    
    private var myContext: UInt8 = 3

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moveAnnotationImageView: UIImageView!
    
    let identifier = "annotation"
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        _locationManager.distanceFilter = kCLLocationAccuracyKilometer
        return _locationManager
    }()

    var location: CLLocation? {
        didSet {
            if location != nil && location != oldValue {
                if annotation.coordinate.latitude != location!.coordinate.latitude || annotation.coordinate.longitude != location!.coordinate.longitude {
                    annotation.coordinate = location!.coordinate
                }
                guard oldValue == nil && locationName != nil else {
                    geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                        self.locationName = placemarks?.first?.name
                    })
                    return
                }
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInformation(subject: "New Note", location: nil, locationName: nil)
        
        tagTextField.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        
        locationManager.requestWhenInUseAuthorization()
        setupMapView()
        
    }
    
    func setInformation(subject subject: String, location: CLLocation?, locationName: String?) {
        annotation.title = subject
        self.location = location
        self.locationName = locationName
    }
    
    func setupMapView() {
        if location == nil {
            locationManager.startUpdatingLocation()
        } else {
            let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(location!.coordinate, regionDistance, regionDistance))
            self.mapView.setRegion(region, animated: false)
        }
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
        let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(location!.coordinate, regionDistance, regionDistance))
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc
    func handlePinchGesture(gestureRecognizer: UIPinchGestureRecognizer) {
        regionDistance = min(max(300, regionDistance / Double(gestureRecognizer.scale)), 10000000)
        let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(location!.coordinate, regionDistance, regionDistance))
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

}

extension NewNoteDetailsViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        self.mapView.addAnnotation(annotation)
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .Ending:
            self.location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        default:
            break
        }
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if let view = mapView.viewForAnnotation(annotation) {
            view.alpha = 0.5
        }
        moveAnnotationImageView.hidden = false
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.location = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        if let view = mapView.viewForAnnotation(annotation) {
            view.alpha = 1
        }
        moveAnnotationImageView.hidden = true
    }
    
}

extension NewNoteDetailsViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            let region = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(self.location!.coordinate, regionDistance, regionDistance))
            self.mapView.setRegion(region, animated: false)
            self.locationManager.stopUpdatingLocation()
        }
    }
}

extension NewNoteDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}