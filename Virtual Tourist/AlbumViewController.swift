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
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        setMap()
        loadPhotos()
        
        if photos.count > 0 {
            guard (photos[0].imageData != nil) else {
                retrivePhotos()
                return
            }
        }
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
            print(photos)
            collectionView.reloadData()
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
                        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
//                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

// TODO: load view controller with coredata 
extension AlbumViewController: UICollectionViewDelegate {
    
    
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumViewCell", for: indexPath) as! AlbumCollectionViewCell
        let photo = photos[indexPath.row]
        
        if let data = photo.imageData as Data? {
            cell.imageView.image = UIImage(data: data)
        }

//        print(photo.url!)
//        cell.url = photo.url!
        return cell
    }
    
}
