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
    
    var requestEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
