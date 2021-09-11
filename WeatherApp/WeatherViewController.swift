//
//  ViewController.swift
//  WeatherApp
//
//  Created by Polina Reznik on 08/05/2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var spinnerActivityIndicator: UIActivityIndicatorView!
    
    private let weatherManager = WeatherManagerViewModel()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        setupActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestLocation()
        startAnimatingActivityIndicator()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextField.endEditing(true)
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if let cityName = searchTextField.text {
            checkDataAndSearch(by: cityName)
        }
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        startAnimatingActivityIndicator()
        locationManager.requestLocation()
    }
}

extension WeatherViewController {
    private func checkDataAndSearch(by cityName: String) {
        let cityNameForSearch = weatherManager.checkInput(string: cityName)
        searchWeather(by: cityNameForSearch)
        textFieldDidEndEditing(searchTextField)
    }
    
    private func searchWeather(by cityName: String) {
        weatherManager.weatherIn(cityName) { [weak self] weatherData, error in
            guard error == nil else {
                print(error.debugDescription)
                DispatchQueue.main.async {
                    self?.presentAlert(with: error?.localizedDescription ?? "error string")
                }
                return
            }
            DispatchQueue.main.async {
                self?.nameLabel.text = weatherData?.name
                self?.temperatureValueLabel.text = self?.weatherManager.temprature(value: (weatherData?.main.temp) ?? 0)
            }
        }
    }
}

extension WeatherViewController {
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func clearTextField() {
        searchTextField.text = ""
        searchTextField.endEditing(true)
    }
    
    private func startAnimatingActivityIndicator() {
        spinnerActivityIndicator.startAnimating()
    }
    
    private func stopAnimatingActivityIndicator() {
        spinnerActivityIndicator.stopAnimating()
    }
    
    private func setupActivityIndicator() {
        spinnerActivityIndicator.hidesWhenStopped = true
        spinnerActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        clearTextField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let cityName = searchTextField.text {
            checkDataAndSearch(by: cityName)
        }
        return true
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.weatherFromLocation(lat: latitude, lon: longitude) { weatherData, error in
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                DispatchQueue.main.async {
                    self.nameLabel.text = weatherData?.name
                    self.temperatureValueLabel.text = self.weatherManager.temprature(value: (weatherData?.main.temp) ?? 0)
                    self.stopAnimatingActivityIndicator()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
