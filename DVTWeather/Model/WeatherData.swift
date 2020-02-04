//
//  WeatherData.swift
//  Clima
//
//  Created by Pallavi Chouhan on 2020/01/15.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherData:Decodable {
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main:Decodable {
    let temp:Double
}

struct Weather:Decodable {
    let description :String
    let id : Int
}

