//
//  WeatherManagerErrorHandler.swift
//  WeatherApp
//
//  Created by Polina Reznik on 19/08/2021.
//

import Foundation

enum WeatherManagerError: Error {
    case badData
    case emptyData
    case badUrl
    
}

extension WeatherManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badData:
            return NSLocalizedString("Something happened with required data", comment: "")
        case .badUrl:
            return NSLocalizedString("Something went wrong with url", comment: "")
        case .emptyData:
            return NSLocalizedString("No data", comment: "")
        }
    }
}
