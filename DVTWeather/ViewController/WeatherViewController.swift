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
    @IBOutlet weak var tempDetailBackgroundView: UIView!
    
    @IBOutlet weak var humidityLbl: UILabel!
    
    @IBOutlet weak var feelslikeLbl: UILabel!
    var weatherPresenter = WeatherPresenter()
    var weatherInteractor : WeatherInteractor?
    var weatherUserDefaults = WeatherUserDefaults()
    var locationManager = CLLocationManager()
    var forecastTempList:Array<Double> = []
    var dayTempList:Array<String> = []
    var imageTempList:Array<String> = []
    var cityname:String!

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherForcaseTableView.dataSource = self
        weatherForcaseTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        weatherForcaseTableView.separatorColor = UIColor.clear
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
       weatherPresenter.delegate = self
       weatherInteractor = WeatherInteractor(weatherPresenter: weatherPresenter)
        
    }

    @IBAction func refreshLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
       // MARK: - Navigation
       // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == K.favSegueIdentifier {
            if let favViewController =  segue.destination as? WeatherFavouritesViewController {
                favViewController.favouriteScreenViewColor = weatherForcaseTableView.backgroundColor!
            }
        }
    }
       
}

//MARK: - WeatherPresenterDelegate

extension WeatherViewController: WeatherPresenterDelegate {
    
     func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLbl.text = weather.temperatureString
            self.currentTempLbl.text = weather.temperatureString
            self.tempConditionLbl.text = weather.tempconditionName
            self.conditionImageView.image = UIImage(named: weather.conditionName)
            self.minTempLbl.text = weather.minTemperatureString
            self.maxTempLbl.text = weather.maxTemperatureString
            self.tempDetailBackgroundView.backgroundColor = weather.colorName
            self.forecastTempList = weather.forecastList;
            self.dayTempList = weather.dayList
            self.imageTempList = weather.forecastImageList
            self.cityname = weather.cityName
            self.humidityLbl.text = weather.humidityString
            self.feelslikeLbl.text = weather.feelsLikeString
            self.weatherForcaseTableView.backgroundColor = weather.colorName
            self.weatherForcaseTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {

        let alertController = UIAlertController(title: "Error", message:
        error.localizedDescription, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
           self.present(alertController, animated: true, completion: nil)
        }
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
            weatherInteractor?.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        DispatchQueue.main.async {

               let alertController = UIAlertController(title: "Error", message:
               error.localizedDescription, preferredStyle: .alert)
                  alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                  self.present(alertController, animated: true, completion: nil)
               }
    
    }
}

//MARK: - UITableViewDataSource

extension WeatherViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastTempList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let temperature  = forecastTempList[indexPath.row]
        
        let day = dayTempList[indexPath.row]
        let image = imageTempList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ForecastTableViewCell
        cell.backgroundColor = weatherForcaseTableView.backgroundColor
        cell.dayForecastLbl.text = day
        cell.tempForecastLbl.text = String(format: "%.1f", temperature)
        cell.imageForecastLbl.image = UIImage(named: image)
        cell.imageForecastLbl.image?.withTintColor(UIColor.white)
        
        return cell
    }
}

