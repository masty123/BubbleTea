//
//  ViewController.swift
//  BubbleTeaLocation
//
//  Created by Theeruth Borisuth on 14/2/19.
//  Copyright © 2019 Theeruth Borisuth. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager();
    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func findBubbleTea(_ sender: Any) {
//        print("tap")
        Alamofire.request("https://api.foursquare.com/v2/venues/search?client_id=J52SCPN4CF1P2ECUTOX003222DBJ0YWJBQWFCRJA0YFPWC4I&client_secret=0AYQKY5OZQNRQE1TIFFUJZHZ3SZTWBX4U33QD3JZQBBMYP3N&v=20180323&limit=10&ll=\(locationManager.location?.coordinate.latitude ?? 0.0),\(locationManager.location?.coordinate.longitude ?? 0.0)&query=bubble+Tea").responseJSON(completionHandler: { res in
            guard let json = res.result.value as? [String: Any] else {
                return
            }
            guard let response = json["response"] as? [String: Any] else {
                return
            }
            guard let venues = response["venues"] as? [[String: Any]] else {
                return
            }
            
            venues.forEach { venue in
                let place = Place(venue: venue)
                //let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude))
                let marker = GMSMarker(position: place.location)
                marker.title = place.name
                marker.map = self.mapView
                print(place.name)
            }
        })
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: 40, longitude: -120))
        marker.map = mapView
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print(status.rawValue)
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
           
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
         mapView.camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10)
    }
    
}
