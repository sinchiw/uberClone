//
//  RiderViewController.swift
//  UberClone
//
//  Created by Wilmer sinchi on 6/4/19.
//  Copyright © 2019 Wilmer sinchi. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class RiderViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var callInButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var userLocation = CLLocationCoordinate2D()
    
    
    var locationManger = CLLocationManager()
    var uberHasBeenCalled = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let cordinate = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: cordinate.latitude, longitude: cordinate.longitude)
            //span to see how big the map you want to be zoom in
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05   ))
            mapView.setRegion(region, animated: true)
            
            //so it doesnt give new annotation everytime it is updated
            mapView.removeAnnotations(mapView.annotations)
            
            //to create a pin in the map
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "My Location"
            mapView.addAnnotation(annotation)
//            annotationPoint(annotation: MKPointAnnotation(), coordinate: center, title: "My Location")
            
        }
        
    }
//
//    func annotationPoint(annotation: MKPointAnnotation, coordinate: Any?, title: String){
//
//
//        return mapView.addAnnotation(annotation)
//
//    }
    
    @IBAction func logOutAction(_ sender: Any) {
        
        
        
    }
    
   
     @IBAction func callInAction(_ sender: Any) {
        // make sure that you set up the rule so it cna read and write
        
        if let email = Auth.auth().currentUser?.email {
            
     
        
        let rideRequestDictionary : [String:Any] = ["email": email, "lat" :userLocation.latitude, "long":userLocation.longitude]
        Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
        
            print("button clicked")
            
            uberHasBeenCalled = true
            
            callInButton.setTitle("Cancel Uber", for: .normal)
        }
     }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
