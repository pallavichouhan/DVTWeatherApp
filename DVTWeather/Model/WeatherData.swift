//
//  WeatherData.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/01/29.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherData: Codable { 
    let list: [List]
    let city: City
}
struct City:Codable {
    let name:String
    let coord:Dictionary<String,Double>
}
struct List: Codable {
   let main: Main
   let weather: [Weather]
   let dt_txt:String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let feels_like: Double
    let humidity: Double
    
}
struct Weather: Codable {
    let description: String
    let id: Int
}
