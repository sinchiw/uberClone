//
//  AcceptRequestViewController.swift
//  UberClone
//
//  Created by Wilmer sinchi on 6/7/19.
//  Copyright © 2019 Wilmer sinchi. All rights reserved.
//

import UIKit
import Firebase
import MapKit
class AcceptRequestViewController: UIViewController,CLLocationManagerDelegate  {

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //passing info from other viewcontroller to these two
    var requestLocations = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        /* You use the delta values in this structure to indicate the desired zoom level of the map, with smaller delta values corresponding to a higher zoom level. */
        //dont forget to change the sender when it passing through the segues
        
       riderPinAnnotation()
        
        // Do any additional setup after loading the view.
    }
    
    func riderPinAnnotation() {
        //dont forget to change the sender when it passing through the segues
        let region = MKCoordinateRegion(center: requestLocations, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocations
        annotation.title = requestEmail
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func rideRequestAction(_ sender: Any) {
        //grab the rider email and gives the driver location
        //update the ride reuquest
        Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat": self.driverLocation.latitude, "driverLon":self.driverLocation.longitude])
            Database.database().reference().child("RiderRequests").removeAllObservers()
        }
        
        //Give Direction
        let requestCLLocation = CLLocation(latitude: requestLocations.latitude, longitude: requestLocations.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemark, error) in
            //loop trough all of the placemark
            if let placemark = placemark {
                //meanig if there something in the array
                if placemark.count > 0 {
                    let mKPlaceMark = MKPlacemark(placemark: placemark[0])
                    let mapItem = MKMapItem(placemark: mKPlaceMark)
                    mapItem.name = self.requestEmail
//                    dictionary with one key and one value
                    let option = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: option)
                    
                }
                
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
