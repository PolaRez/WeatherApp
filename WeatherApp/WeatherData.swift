
//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Polina Reznik on 09/05/2021.
//

import Foundation

struct WeatherData: Decodable {
    let list: [Weather]
}

struct Weather: Decodable {
    let name: String
    let id: Int
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}


