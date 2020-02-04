//
//  ViewController.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/01/29.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var weatherForcaseTableView: UITableView!
    
    @IBOutlet weak var tempConditionLbl: UILabel!
    @IBOutlet weak var tempDetailBackgroundView: UIStackView!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var forecastTempList:Array<Double> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherForcaseTableView.dataSource = self
        weatherForcaseTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)

        // Do any additional setup after loading the view.
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            weatherManager.delegate = self
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLbl.text = weather.temperatureString
            self.currentTempLbl.text = weather.temperatureString
            self.tempConditionLbl.text = weather.tempconditionName
            self.conditionImageView.image = UIImage(named: weather.conditionName)
            self.minTempLbl.text = weather.minTemperatureString
            self.maxTempLbl.text = weather.maxTemperatureString
            self.tempDetailBackgroundView.backgroundColor = weather.colorName
            self.forecastTempList = weather.forecastList;
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}



//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource

extension WeatherViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastTempList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let temperature  = forecastTempList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ForecastCell
        cell.dayForecastLbl.text = "Monday"
        cell.tempForecastLbl.text = String(format: "0.1f", temperature)

        return cell
    }
}

