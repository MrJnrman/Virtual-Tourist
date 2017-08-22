//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AlbumViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
    
    var annotation: VirtualTouristPointAnnotation!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var photos = [Photo]()
    
    var photoCountBeforeReload = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        setMap()
        loadPhotos()
    }
    
    func setMap() {
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    func loadPhotos() {
        let photoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        
        let predicate = NSPredicate(format: "album = %@", argumentArray: [annotation.pin?.album!])
        photoFetch.predicate = predicate
        
        do {
            photos = try context.fetch(photoFetch) as! [Photo]
            collectionView.reloadData()
            if photos.count > 0 {
                guard (photos[0].imageData != nil) else {
                    retrivePhotos()
                    return
                }
            }
        } catch {
            print("error retrieving photos")
        }
    }
    
    // retrive images in the background and update each cell as they become available
    func retrivePhotos() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { () -> Void in
            for index in 0..<self.photos.count {
                let imageUrl = URL(string: self.photos[index].url!)
                
                if let imageData = try? Data(contentsOf: imageUrl!) {
                    self.photos[index].imageData = imageData as NSData
                    
                    performUIUpdatesOnMain {
                        let indexPath = IndexPath(row: index, section: 0)
                        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumViewCell", for: indexPath) as! AlbumCollectionViewCell
                        self.collectionView.reloadItems(at: [indexPath])
                        cell.hideActivityIndicator()
                    }
                }
            }
        }
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
    
    @IBAction func newCollectionPressed(_ sender: Any) {
        _ = HttpManager.shared.taskForGETRequest((annotation.pin?.latitude)!, (annotation.pin?.longitude)!, completionHandler: { (results, error) in
            
            guard (error == nil) else {
                self.showAlertView(title: "An Error Occured!", message: "Unable to retrive photo data", buttonText: "Dismiss")
                self.hideActivityIndicator()
                return
            }
            
            //TODO: Empty photos array before data is pulled
            //TODO: possibly create a function which starts changes each cell item to a placeholder and clal before loadphotos
            performUIUpdatesOnMain {
                self.photoCountBeforeReload = self.photos.count
                self.photos = [Photo]()
                self.collectionView.reloadData()
            }
            
            FlickrPhotos.shared.parse(results!, pin: self.annotation.pin!, context: self.context)
            self.loadPhotos()
        })
    }
}

// TODO: load view controller with coredata
extension AlbumViewController: UICollectionViewDelegate {    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        context.delete(photos[indexPath.row])
        photos.remove(at: indexPath.row)
        
        
        do {
            try context.save()
        } catch {
            print("error while trying to save")
        }
        
        collectionView.deleteItems(at: [indexPath])
        return true
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if photos.count < 1 {
            return photoCountBeforeReload
        }
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumViewCell", for: indexPath) as! AlbumCollectionViewCell
        
        cell.showActivityIndicator()
        
        if photos.count > 0 {
            let photo = photos[indexPath.row]
            
            if let data = photo.imageData as Data? {
                cell.imageView.image = UIImage(data: data)
                cell.hideActivityIndicator()
            }
        } else {
            cell.imageView.image = nil
            cell.hideActivityIndicator()
        }
        
        return cell
    }
    
}
