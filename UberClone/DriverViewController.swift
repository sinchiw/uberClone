//
//  DriverViewController.swift
//  UberClone
//
//  Created by Wilmer sinchi on 6/6/19.
//  Copyright © 2019 Wilmer sinchi. All rights reserved.
//

import UIKit
import Firebase
import MapKit
//33:48 wher you left off\

class DriverViewController: UITableViewController,CLLocationManagerDelegate {

    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var driverLocation = CLLocationCoordinate2D()
    
    
    var locationManger = CLLocationManager()

    
    //an array for the datatable
    var rideRequest : [DataSnapshot] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        tabledata()
        
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate {
            driverLocation = coor
        }
    }
    
    func tabledata(){
        //to grab data and put inro am array
        Database.database().reference().child("RideRequests").observe(.childAdded) { (snapshot) in
            
            self.rideRequest.append(snapshot)
            // refresh everytime a new data is added
            self.tableView.reloadData()
        }
        //where the new point is being reolace and new locations
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
        
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideRequest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return nil
        // dont forget to name or change the cell identifier in the inspectorView to resuseIdentifier!!!
        let cell = tableView.dequeueReusableCell(withIdentifier: "resuseIdentifier", for: indexPath)
        
        let snapshot = rideRequest[indexPath.row]
        if let rideRequestDictionary = snapshot.value as? [String:AnyObject]{
        //unwrap the email in the dictionary
        if let email = rideRequestDictionary["email"] as? String {
            //once you can get the email info, now we need to get the lat and long info from the rider information
            if let lat = rideRequestDictionary["lat"] as? Double {
                if let long = rideRequestDictionary["long"] as? Double {
                    let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                    //get the lat and long from the dictionary
                    let riderCLLocation = CLLocation(latitude: lat, longitude: long)
                    let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
                    //round the distance by 100
                    let roundedDistance = round(distance * 100) / 100
                    cell.textLabel?.text = "\(email) is \(roundedDistance)km away"
                    
                }
            }
           

            }
           
        }
        
        
//        cell.textLabel?.text = "Hello"
        return cell
        
    }
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //we are gonna proivde something in the sender
        let snapshot = rideRequest[indexPath.row]
        performSegue(withIdentifier: "DriverMap", sender: snapshot)
    }
    
    // this functions allow me to
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let acceptVC = segue.destination as? AcceptRequestViewController{
            if let snapshot = sender as? DataSnapshot {
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject]{
                    //unwrap the email in the dictionary
                    if let email = rideRequestDictionary["email"] as? String {
                        //once you can get the email info, now we need to get the lat and long info from the rider information
                        if let lat = rideRequestDictionary["lat"] as? Double {
                            if let long = rideRequestDictionary["long"] as? Double {
                                acceptVC.requestEmail = email
                                
                                let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                acceptVC.requestLocations = location
                            }
                        }
                    }
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
