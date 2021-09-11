//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Polina Reznik on 09/05/2021.
//

import Foundation
import UIKit


class WeatherManagerViewModel {
    func weatherIn(_ cityName: String, complition: @escaping (Weather?, Error?) -> (Void)) {
        WeatherManagerModel.shared.getWeatherIn(cityName) { weatherObject, error in
            guard error == nil else {
                complition(nil, error)
                return
            }
            complition(weatherObject, nil)
        }
    }
    
    func weatherFromLocation(lat: Double, lon: Double, complition: @escaping (Weather?, Error?) -> (Void)) {
        WeatherManagerModel.shared.getLocationData(lat: lat, lon: lon) { weatherObject, error in
            guard error == nil else {
                complition(nil, error)
                return
            }
            complition(weatherObject, nil)
        }
    }
    
    func temprature(value temp: Double) -> String {
        return WeatherManagerModel.shared.convertTempratureToString(temp)
    }
    
    func checkInput(string cityName: String) -> String {
        return WeatherManagerModel.shared.inputStringValidation(cityName)
    }
}
