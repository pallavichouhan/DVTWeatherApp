//
//  WeatherUserDefaults.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/02/01.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import Foundation

struct  WeatherUserDefaults {

    let defaults = UserDefaults.standard
    
    func setLastTimeAppOpendByUser() {
        defaults.set(Date(),forKey: K.lastUpdatedTime)
    }
    func getLatTimeAppOpenedByuser() -> NSDate {
        let appLastOpen = defaults.object(forKey: K.lastUpdatedTime)
        return appLastOpen as! NSDate
    }
    func setLocationToFavourites(locationWithNameTempAndCoord:Array<FavouriteTemperatureData>){
        
       defaults.set(try? PropertyListEncoder().encode(locationWithNameTempAndCoord), forKey:K.favouriteUserLocation)
        
    }
    
    func getFavouritesLocation() -> Array<FavouriteTemperatureData>?{
        if let data = defaults.value(forKey:K.favouriteUserLocation) as? Data {
        let favLocationList = try? PropertyListDecoder().decode(Array<FavouriteTemperatureData>.self, from: data)
            return favLocationList!
        }else {
            return nil
        }
    }
}

struct FavouriteTemperatureData:Codable {
    let favcity:String
    let favCityTemperature:Double
    let favCityLatitude:Double
    let favCityLongitude:Double
}
