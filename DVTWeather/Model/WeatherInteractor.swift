//
//  WeatherManager.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/01/29.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherInteractor, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherInteractor {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=45241f2ad932622fabb1205d43e720f8&mode=json&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let list = decodedData.list
            let city = decodedData.city
            print(city)
            let id = list[0].weather[0].id
            let temp = list[0].main.temp
            let name = list[0].weather[0].description
            let minTemp = list[0].main.temp_min
            let maxTemp = list[0].main.temp_max
            let cityname = city.name
           
            
            //Reading the every 8th date for 5 day forecast.
            var readingNumber = 0
            var dayNumber = 0
            var tempArray = [Double]()
            var dayArray = [String]()
            var tempImageArray = [String]()
            for dict in list {
                let mainDictionary = dict.main
                let maintemp = mainDictionary.temp
                if readingNumber == 0 {
                    tempArray.append(maintemp)
                    dayArray.append(getDayOfWeek(dict.dt_txt)!)
                    tempImageArray.append(gettempImage(id: dict.weather[0].id))
                }else if maintemp > tempArray[dayNumber]{
                    tempArray[dayNumber] = maintemp
                    dayArray[dayNumber] = getDayOfWeek(dict.dt_txt)!
                    tempImageArray[dayNumber] = gettempImage(id: dict.weather[0].id)
                }
                readingNumber += 1
                if readingNumber == 8 {
                    readingNumber = 0
                    dayNumber += 1
                }
            }
            
            //Saving the weather forecast into model
            let weather = WeatherModel(conditionId: id, tempconditionName: name, temperature: temp, minTemperature: minTemp, maxTemperature:maxTemp,forecastList: tempArray,dayList: dayArray,forecastImageList: tempImageArray,cityName: cityname)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARk:- To get the Day of the Week
   func getDayOfWeek(_ today:String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Saturday"
        }
    }
    
    func gettempImage(id:Int) -> String {
        switch id {
        case 200...622:
            return "rain"
        case 701...781:
            return "partlysunny"
        case 800:
            return "clear"
        case 801...804:
            return "partlysunny"
        default:
            return "partlysunny"
        }
    }
    
    func getCurrentColor() {
        
    }
    
}



