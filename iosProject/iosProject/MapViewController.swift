//
//  MapViewController.swift
//  iosProject
//
//  Created by VRBX on 2020-06-23.
//  Copyright © 2020 VRBX All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var textView: UITextView!
    var lat: Double = 0
    var long: Double = 0
    let cord = CLLocationCoordinate2D()
   // let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    //    locationManager.delegate = self
        mapView.delegate = self
        
        var mapRegion = MKCoordinateRegion()
        
        mapRegion.center.latitude = lat
        mapRegion.center.longitude = long
        mapRegion.span.latitudeDelta = 1
        mapRegion.span.longitudeDelta = 1
        
        self.mapView.region = mapRegion
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        mapView.addAnnotation(annotation)
        
       // textView.text? = "\(lat)\(long)"
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
