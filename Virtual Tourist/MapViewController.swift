//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        retrievePins()
    }
    
    @IBAction func dropPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let locationCoordinates = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        showActivityIndicator()
        
        _ = HttpManager.shared.taskForGETRequest(locationCoordinates.latitude, locationCoordinates.longitude, completionHandler: { (results, error) in
            
            guard (error == nil) else {
                print(error)
                return
            }
            
            let pin = Pin(latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude, context: self.context)
            
            FlickrPhotos.shared.buildAndSave(results!, pin: pin, context: self.context)
            
            performUIUpdatesOnMain {
                self.mapView.addAnnotation(self.createAnnotation(latitude: pin.latitude, longitude: pin.longitude))
                self.hideActivityIndicator()
            }
        })
        
        // Added Pi
//        mapView.addAnnotation(createAnnotation(latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude))
        
    }
    
    func retrievePins() {
        let pinFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let fetchedPins = try context.fetch(pinFetch) as! [Pin]
            loadPins(pins: fetchedPins)
        } catch {
            fatalError("Failed to fetch pins")
        }
    }
    
    func loadPins(pins: [Pin]) {
        var annotations = [MKPointAnnotation]()
        
        for pin in pins {
            annotations.append(createAnnotation(latitude: pin.latitude, longitude: pin.longitude))
//            let nss = pin.album?.photos?.allObjects as? [Photo]
//            for p in nss! {
//                print(p.title)
//            }
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    func createAnnotation(latitude: Double, longitude: Double) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = centerCoordinate
        
        return annotation
    }
    
    func showActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .purple
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
