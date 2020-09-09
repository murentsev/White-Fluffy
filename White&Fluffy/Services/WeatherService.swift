//
//  WeatherService.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 07.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class WeatherService {
    
    let baseUrl = "https://api.weather.yandex.ru/v2/forecast"
    let apiKey = "X-Yandex-API-Key"
    let apiKeyValue = "491d1624-9529-490e-a220-1d78b4af383d"
    
    enum WetherMethod {
        case mainUpdate
        case addNewCity
        case cityWeather
    }
    
    func getCity(lat: String, lon: String, setName: String, completion: ((WeatherResponse) -> Void)? = nil) {
        let parameters: Parameters = [
            "lat": lat,
            "lon": lon
        ]
        let headers : HTTPHeaders = [apiKey:apiKeyValue]
        AF.request(baseUrl,method: HTTPMethod(rawValue: "GET"), parameters: parameters, headers: headers).responseData { [weak self] (response) in
            if let data = response.data {
                print(response.value)
                do {
                    let city = try JSONDecoder().decode(WeatherResponse.self, from: data).info
                    city.url = setName
                    self?.saveCity(city: city, name: setName)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getFactWeather(lat: String, lon: String, completion: ((FactWeather) -> Void)? = nil) {
        let parameters: Parameters = [
            "lat": lat,
            "lon": lon
        ]
        let headers : HTTPHeaders = [apiKey:apiKeyValue]
        AF.request(baseUrl,method: HTTPMethod(rawValue: "GET"), parameters: parameters, headers: headers).responseData { response in
            if let data = response.data {
               // print(response.value)
                do {
                    let fact = try JSONDecoder().decode(WeatherResponse.self, from: data).fact
                    completion?(fact)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    func getForecast(lat: String, lon: String, completion: (([Forecast]) -> Void)? = nil) {
        let parameters: Parameters = [
            "lat": lat,
            "lon": lon
        ]
        let headers : HTTPHeaders = [apiKey:apiKeyValue]
        AF.request(baseUrl,method: HTTPMethod(rawValue: "GET"), parameters: parameters, headers: headers).responseData { response in
            if let data = response.data {
               // print(response.value)
                do {
                    let forecasts = try JSONDecoder().decode(WeatherResponse.self, from: data).forecasts
                    completion?(forecasts)
                } catch {
                    print(error)
                }
            }
        }
    }
    
       
    func saveCity(city: City, name: String) {
        do {
            let realm = try Realm()
            
            if let oldCity = realm.object(ofType: City.self, forPrimaryKey: name) {
               realm.delete(oldCity)
            }
            
            try realm.write {
                realm.add(city, update: .modified)
            }
        } catch {
            print(error)
        }
    }
}
