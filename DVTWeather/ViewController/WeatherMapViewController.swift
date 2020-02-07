//
//  WeatherMapViewController.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/02/04.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMapsBase
import MapKit

class WeatherMapViewController: UIViewController {
    
    var coordinate: CLLocationCoordinate2D?
    var name:String?
    var address:String?
        
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        placesClient = GMSPlacesClient.shared()
        getCurrentPlace()
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func getCurrentPlace() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.name = place.name
                    self.address = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                    self.coordinate = place.coordinate
                    let annotation = MKPointAnnotation()
                    //annotation.title = title
                    annotation.coordinate = self.coordinate!
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
}


