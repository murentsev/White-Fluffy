//
//  WeatherResponse.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 07.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    var fact: FactWeather
    var info: City
    var forecasts: [Forecast]
}

struct FactWeather: Decodable {
    let temp: Int
    let icon: String
}

struct Forecast: Decodable {
    var date: String
    var hours: [WeatherHour]
}

struct WeatherHour: Decodable {
    var hour: String
    var icon: String
    var temp: Int

}
