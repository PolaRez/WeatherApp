//
//  WeatherManagerModel.swift
//  WeatherApp
//
//  Created by Polina Reznik on 10/09/2021.
//

import Foundation

class WeatherManagerModel {
    static let shared = WeatherManagerModel()
    private let basicURL = "https://api.openweathermap.org/data/2.5/find?appid=aadb230e1b194bd428080cba12bbb839&units=metric"
    
    private func getLocationUrl(_ lat: Double, _ lon: Double) -> String {
        let url = "\(basicURL)&lat=\(lat)&lon=\(lon)"
        return url
    }
    
    private func getUrlBy(_ city: String) -> String {
        let url = "\(basicURL)&q=\(city)"
        return url
    }
    
    private func getDataFrom(url: String, complition: @escaping (Data?, Error?) -> (Void)) {
        guard let url = URL(string: url) else {
            complition(nil, WeatherManagerError.badUrl)
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                complition(nil, error)
                return
            }
            guard let data = data else {
                complition(nil, WeatherManagerError.badData)
                return
            }
            complition(data, nil)
        }
        task.resume()
    }
    
    private func decodeDataToWeather(_ data: Data) -> Weather? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            return decodedData.list.first
        } catch {
            return nil
        }
    }
    
    private func getDecodedData(url: String, complition: @escaping (Weather?, Error?) -> (Void)) {
        getDataFrom(url: url) { data, error in
            guard error == nil else {
                complition(nil, error)
                return
            }
            guard let data = data else {
                complition(nil, WeatherManagerError.badData)
                return
            }
            guard let weatherDataObject = self.decodeDataToWeather(data) else {
                complition(nil, error)
                return
            }
            complition(weatherDataObject, nil)
        }
    }
    
    func getLocationData(lat: Double, lon: Double, complition: @escaping (Weather?, Error?) -> (Void)) {
        let url = getLocationUrl(lat, lon)
        getDecodedData(url: url) { weatherObject, error in
            guard error == nil else {
                complition(nil, error)
                return
            }
            complition(weatherObject, nil)
        }
    }
    
    func getWeatherIn(_ cityName: String, complition: @escaping (Weather?, Error?) -> (Void)) {
        let url = getUrlBy(cityName)
        getDecodedData(url: url) { weatherObject, error in
            guard error == nil else {
                complition(nil, error)
                return
            }
            complition(weatherObject, nil)
        }
    }
}

extension WeatherManagerModel {
    func convertTempratureToString(_ temp: Double) -> String {
        return String(format: "%.1f", temp)
    }
    
    func inputStringValidation(_ cityName: String) -> String {
        var newString = cityName
            if newString.last == " " {
                newString.removeLast()
            }
            if newString.contains(" ") {
                newString = cityName.replacingOccurrences(of: " ", with: "%20")
            }
        return newString
    }
}
