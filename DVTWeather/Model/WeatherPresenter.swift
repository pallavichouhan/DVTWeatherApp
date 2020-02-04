//
//  WeatherPresenter.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/02/03.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import Foundation

protocol WeatherPresenterDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherPresenter {
    
    var delegate: WeatherPresenterDelegate?
    
    func weatherServiceSuccess(weather: WeatherModel){
        delegate?.didUpdateWeather(weather: weather)
    }
    
    func weatherServicefailure(error:Error){
        delegate?.didFailWithError(error: error)

    }
}
