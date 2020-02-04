//
//  WeatherSettingsViewController.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/01/31.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import UIKit

class WeatherFavouritesViewController: UIViewController {
    @IBOutlet weak var favouritesTableView: UITableView!
    
    var favouriteCityList:Array<String> = []
    var favouriteCityTemperatureList:Array<Double> = []
    
    
    var favouriteScreenViewColor:UIColor = UIColor()
    var weatherPresenter = WeatherPresenter()
    var weatherInteractor:WeatherInteractor?
    var weatherUserDefaults = WeatherUserDefaults()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        favouritesTableView.register(UITableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        favouritesTableView.dataSource = self

        view.backgroundColor = favouriteScreenViewColor
        favouritesTableView.backgroundColor = UIColor.clear
        favouritesTableView.separatorColor = UIColor.white
        getFavLocationListFromDefaults()
        favouritesTableView.reloadData()
        weatherPresenter.delegate = self
        weatherInteractor = WeatherInteractor(weatherPresenter: weatherPresenter)

    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        searchTextField.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func getFavLocationListFromDefaults() {
        print("Get the fav Location List")
        
        let favLocations = self.weatherUserDefaults.getFavouritesLocation()
        for favLoc in favLocations! {
            let city = favLoc.favcity
            let temp = favLoc.favCityTemperature
            favouriteCityList.append(city)
            favouriteCityTemperatureList.append(temp)
        }
    }
    
    func saveFavouriteListToDefaults(with cityName:String, temperature:Double) {
        var favLocationList:Array<FavouriteTemperatureData>=Array()
        let favLocations = self.weatherUserDefaults.getFavouritesLocation()
        for favLoc in favLocations! {
            favLocationList.append(favLoc)
        }
        
        let favLocation:FavouriteTemperatureData = FavouriteTemperatureData(favcity: cityName, favCityTemperature: temperature)
        favLocationList.append(favLocation)
        self.weatherUserDefaults.setLocationToFavourites(locationWithNameAndTemp: favLocationList)
        print(favLocationList)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == K.weatherMapViewIdentifier {
            if let mapViewController =  segue.destination as? WeatherMapViewController {
               
            }
        }
        
        
     }
     
    
}

//MARK: - UITextFieldDelegate

extension WeatherFavouritesViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Add Location"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            //weatherInteractor.fetchWeather(cityName: city)
            weatherInteractor?.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

extension WeatherFavouritesViewController: WeatherPresenterDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.favouriteCityList.append(weather.cityName)
            self.favouriteCityTemperatureList.append(weather.temperature)
            self.favouritesTableView.reloadData()
            self.saveFavouriteListToDefaults(with: weather.cityName, temperature: weather.temperature)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension WeatherFavouritesViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favCity  = favouriteCityList[indexPath.row]
        let favCitytemperature = String(format: "%.1f"+" °",favouriteCityTemperatureList[indexPath.row])
        
        var cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: K.cellIdentifier)
        cell.backgroundColor = favouriteScreenViewColor
        cell.textLabel!.text = favCity
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = favCitytemperature
        cell.detailTextLabel?.textColor = UIColor.white
        return cell
        
    }
}
