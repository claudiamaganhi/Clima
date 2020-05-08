//
//  WeatherManager.swift
//  Clima
//
//  Created by Claudia Cavalini Maganhi on 07/05/20.
//  Copyright © 2020 Claudia Cavalini Maganhi. All rights reserved.
//

import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel, _ weatherManager: WeatherManager)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
  
    let weatherUrl: String = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=783335b50948e0c5a812326913446566"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(at cityName: String) {
        let urlString = "\(weatherUrl)&q=\(getCityName(cityName))"
        performRequest(urlString: urlString)
    }
    
    func getCityName(_ cityname: String) -> String {
        let city = cityname.replacingOccurrences(of: " ", with: "+")
        return city.lowercased()
    }
    
    private func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                self.delegate?.didFailWithError(error!)
            }
            
            if let data = data {
                if let weather = self.parseJSON(weatherData: data) {
                    self.delegate?.didUpdateWeather(weather, self)
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let weatherDecodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = weatherDecodedData.weather[0].id
            let temperature = weatherDecodedData.main.temp
            let cityName = weatherDecodedData.name
            let weather = WeatherModel(conditionId: id, temperature: temperature, cityName: cityName)
            
            return weather
            
        } catch let error {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
   
}
