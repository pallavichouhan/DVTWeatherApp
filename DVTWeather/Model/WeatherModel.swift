//
//  WeatherModel.swift
//  Clima
//
//  Created by Pallavi Chouhan on 2020/01/16.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel {
    
    let conditionId :Int
    let cityName: String
    let temperature: Double
    
    var tempratureString:String {
        return String(format:"%.1f",temperature)
    }
    
    var conditionName:String {
        
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.bolt"
        case 500...531:
            return "cloud.bolt"
        case 600...622:
            return "cloud.bolt"
        case 700...781:
            return "cloud.bolt"
        case 800:
            return "cloud.bolt"
        case 801...804:
            return "cloud.bolt"
        default:
            return ""
        }
    }
    
}
