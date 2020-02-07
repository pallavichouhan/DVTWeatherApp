//
//  WeatherModel.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/01/29.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct WeatherModel {
    let conditionId: Int
    let tempconditionName: String
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let forecastList:Array<Double>
    let dayList:Array<String>
    let forecastImageList:Array<String>
    let cityName:String
    let feelslike:Double
    let humidity:Int
    let coordinate:Dictionary<String,Double>
    
    var temperatureString: String {
        return String(format: "%.1f"+" °", temperature)
    }
    
    var maxTemperatureString: String {
        return String(format: "%.1f"+" °", minTemperature)
    }
    
    var minTemperatureString: String {
        return String(format: "%.1f"+" °", maxTemperature)
    }
    
    var humidityString: String {
        return String(format: "Humidity:"+"%.1d", humidity)
    }
    
    var feelsLikeString: String {
        return String(format: "Feelslike:"+"%.1f"+" °", feelslike)
    }
    
    
    var conditionName: String {
        switch conditionId {
        case 200...622:
            return "forest_rainy"
        case 701...781:
            return "forest_cloudy"
        case 800:
            return "forest_sunny"
        case 801...804:
            return "forest_cloudy"
        default:
            return "forest_cloudy"
        }
    }
    
    var colorName: UIColor {
        switch conditionId {
        case 200...622:
            return UIColor(red: 87.0/255.0, green: 87.0/255.0, blue: 92.0/255.0, alpha: 1)
        case 701...781:
            return UIColor(red: 90.0/255.0, green: 112.0/255.0, blue: 121.0/255.0, alpha: 1)
        case 800:
            return UIColor(red: 99.0/255.0, green: 168.0/255.0, blue: 67.0/255.0, alpha: 1)
        case 801...804:
            return UIColor(red: 90.0/255.0, green: 112.0/255.0, blue: 121.0/255.0, alpha: 1)
        default:
            return UIColor(red: 90.0/255.0, green: 112.0/255.0, blue: 121.0/255.0, alpha: 1)
        }
    }
    
}
