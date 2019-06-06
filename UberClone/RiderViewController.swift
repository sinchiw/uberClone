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
        checkIfUberCalled()
    }
    
    
    @IBAction func getUserLocation(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManger.startUpdatingLocation()
            
            
           
            
        }
        
    }
    
    func checkIfUberCalled(){
        //this func help see if uber has been called when your logged out.. it first check the info in the database, if there is than the title of the button will chnage and the snapref,remove.value wont be called since we did mot implemtied 
        if let email = Auth.auth().currentUser?.email{
            Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapchat) in
                //if we find any information, we dont want to remove the value
                //                snapchat.ref.removeValue() // that why we dont nees this code here
                self.uberHasBeenCalled = true
                self.callInButton.setTitle("Cancel Uber", for: .normal)
                Database.database().reference().child("RideRequests").removeAllObservers()
                
                
            }
            
        }
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
            
            //to create a pin in the map, the red, you can also customize it with your desire
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
        //to create your own custom animation!
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        //must have a try
        try? Auth.auth().signOut()
        //have the animation false otherwise it wont work
        navigationController?.dismiss(animated: false, completion: nil)
        
        
        
    }
    
   
     @IBAction func callInAction(_ sender: Any) {
        // make sure that you set up the rule so it cna read and write
        
        if let email = Auth.auth().currentUser?.email {
            
            if uberHasBeenCalled {
                uberHasBeenCalled = false
                //change the button once the button has been tapped, it change the button title
                callInButton.setTitle("Call in Uber", for: .normal)
                //to find or accesing the currrent email in firebase database that has RideRequest,
                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapchat) in
                    /*if you leave it like this it would delte everything under RiderRequest snapchat.ref.removeValue(), but also when you call in uber it will also delete it as well becuase when the childisadded it would delte it right away  since it will always try to listen and remove the value, to fix this we havet oremove the obsever so it can stop right away */
                    snapchat.ref.removeValue()
                    
                    Database.database().reference().child("RideRequests").removeAllObservers()
                }
                
                
            } else {
                
            
     //update the database with the location ofthe current location,
        
        let rideRequestDictionary : [String:Any] = ["email": email, "lat" :userLocation.latitude, "long":userLocation.longitude]
        Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
        
            print("button clicked")
            //so we know that uber has been called
            uberHasBeenCalled = true
            //change the button once the button has been tapped, it change the button title
            callInButton.setTitle("Cancel Uber", for: .normal)
            }
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
