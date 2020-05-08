//
//  WeatherModel.swift
//  Clima
//
//  Created by Claudia Cavalini Maganhi on 08/05/20.
//  Copyright © 2020 Claudia Cavalini Maganhi. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let temperature: Double
    let cityName: String
    let country: String
    
    var temperatureString: String {
        return String(format: "%.0f", temperature.rounded())
    }
    
    var conditonName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
   
    
}
