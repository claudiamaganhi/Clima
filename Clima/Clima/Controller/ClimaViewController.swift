//
//  ClimaViewController.swift
//  Clima
//
//  Created by Claudia Cavalini Maganhi on 01/05/20.
//  Copyright © 2020 Claudia Cavalini Maganhi. All rights reserved.
//

import UIKit
import CoreLocation

class ClimaViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func search(_ sender: UIButton) {
        if searchTextField.text != "" {
            guard let city = searchTextField.text else { return }
            weatherManager.fetchWeather(at: city)
            searchTextField.endEditing(true)
        }
    }
    
    @IBAction func updateCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    private func presentErrorAlert(_ error: Error) {
        let nserror = error as NSError
        var title: String = ""
        if nserror.code == 4865 {
            title = "Could not find this city"
        } else {
            title = error.localizedDescription
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setDelegates() {
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
    }
    
}

extension ClimaViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weather: WeatherModel, _ weatherManager: WeatherManager) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString) °C"
            self.cityLabel.text = "\(weather.cityName) - \(weather.country)"
            self.conditionImageView.image = UIImage(systemName: weather.conditonName)
        }
    }
    
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            self.presentErrorAlert(error)
        }
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
        if searchTextField.text != "" {
            guard let city = searchTextField.text else { return }
            weatherManager.fetchWeather(at: city)
            searchTextField.text = ""
        }
    }
    
}

extension ClimaViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitute = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitute, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

