//
//  ClimaViewController.swift
//  Clima
//
//  Created by Claudia Cavalini Maganhi on 01/05/20.
//  Copyright © 2020 Claudia Cavalini Maganhi. All rights reserved.
//

import UIKit

class ClimaViewController: UIViewController, WeatherManagerDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }

    @IBAction func search(_ sender: UIButton) {
        guard let city = searchTextField.text else { return }
        weatherManager.fetchWeather(at: city)
        searchTextField.endEditing(true)
    }
    
    @IBAction func updateLocation(_ sender: UIButton) {
    }
    
    func didUpdateWeather(_ weather: WeatherModel, _ weatherManager: WeatherManager) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString) °C"
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditonName)
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: nil, message: "Please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Go again", style: .cancel, handler: nil)
        alert.addAction(action)
        print(error.localizedDescription)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ClimaViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let city = searchTextField.text else { return }
        weatherManager.fetchWeather(at: city)
        searchTextField.text = ""
    }
    
}

