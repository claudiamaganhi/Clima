//
//  WeatherData.swift
//  Clima
//
//  Created by Claudia Cavalini Maganhi on 08/05/20.
//  Copyright © 2020 Claudia Cavalini Maganhi. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}

struct Sys: Codable {
    let country: String
}
