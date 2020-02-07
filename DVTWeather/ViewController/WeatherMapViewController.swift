//
//  WeatherMapViewController.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/02/04.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MapKit

//import CoreLocation

class WeatherMapViewController: UIViewController {
    
    var coordinate: CLLocationCoordinate2D?
    var name:String?
    var address:String?
    var latitude:Double?
    var longitude:Double?
    var geocoder = GMSGeocoder()
    
    var placesClient: GMSPlacesClient!
    var mapView: GMSMapView!
    
    @IBOutlet weak var closeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        placesClient = GMSPlacesClient.shared()
        getTheCompleteAddressfrom(lat: latitude!, long: longitude!)
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude:longitude! , zoom: 6.0)
        //mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y:closeBtn.frame.origin.y+closeBtn.frame.size.height, width: view.frame.size.width, height: view.frame.size.height), camera: camera)
        closeBtn.superview?.bringSubviewToFront(closeBtn)
        view.addSubview(mapView)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func getTheCompleteAddressfrom(lat:Double,long:Double) {
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude:lat,longitude:long)) { (response, error) in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            if let placeDetails = response {
                let firstResult = placeDetails.firstResult()
                let city = firstResult?.locality
                let country = firstResult?.country
                
               // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                marker.title = city
                marker.snippet = country
                marker.map = self.mapView
            }
        }
    }
    
}
