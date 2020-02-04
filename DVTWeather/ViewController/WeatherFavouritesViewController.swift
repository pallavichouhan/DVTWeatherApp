//
//  WeatherSettingsViewController.swift
//  DVTWeather
//
//  Created by Pallavi Chouhan on 2020/01/31.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import UIKit

class WeatherFavouritesViewController: UIViewController {
    @IBOutlet weak var settingsTableView: UITableView!
    
    var settingList:Array<String> = []
    var temperatureList:Array<Double> = []

    
    var settingViewColor:UIColor = UIColor()
    var weatherManager = WeatherManager()
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        settingsTableView.dataSource = self
        weatherManager.delegate = self
        view.backgroundColor = settingViewColor
        settingsTableView.backgroundColor = UIColor.clear
        settingsTableView.separatorColor = UIColor.white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
}


extension WeatherFavouritesViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
    
            self.settingList.append(weather.cityName)
            self.temperatureList.append(weather.temperature)
            self.settingsTableView.reloadData()
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension WeatherFavouritesViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favCity  = settingList[indexPath.row]
        let favCitytemperature = String(format: "%.1f"+" °",temperatureList[indexPath.row])
        
        var cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
            cell = UITableViewCell(style: .value1, reuseIdentifier: K.cellIdentifier)
            cell.backgroundColor = settingViewColor
            cell.textLabel!.text = favCity
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.text = favCitytemperature
            cell.detailTextLabel?.textColor = UIColor.white
            return cell
        
    }
}
