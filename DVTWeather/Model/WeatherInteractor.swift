//
//  WeatherInteractor.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/01/29.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherInteractor:WeatherServiceDelegate {
    
    var weatherService = WeatherService()
    var weatherPresenter:WeatherPresenter?
       
    mutating func fetchWeather(cityName: String) {
        weatherService.delegate = self
        weatherService.fetchWeather(cityName: cityName)
    }
    
    mutating func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        weatherService.delegate = self
        weatherService.fetchWeather(latitude: latitude, longitude: longitude)
    }
    
    func didUpdateWeatherService(_ weatherManager: WeatherService, weather: WeatherModel) {
        weatherPresenter?.weatherServiceSuccess(weather: weather)
    }
    
    func didFailWeatherServiceWithError(error: Error){
        weatherPresenter?.weatherServicefailure(error: error)
        
    }
    
    func showNetworkAlertwith(){
        
    }

}



