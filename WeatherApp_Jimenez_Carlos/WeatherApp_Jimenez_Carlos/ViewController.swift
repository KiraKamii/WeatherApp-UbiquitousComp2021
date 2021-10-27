//
//  ViewController.swift
//  WeatherApp_Jimenez_Carlos
//
//  Created by Carlos Jimenez on 10/19/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var models = [DailyWeather]()
    var current: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    //Location Code
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
       
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=imperial&exclude=minutely,alerts&appid=6aa2143b65318292816763d3c06f2121"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data,response,error in
            guard let data = data, error == nil else {
                print("Something went wrong")
                print(String(describing: error))

                return
            }
            var json: WeatherResponse?
            do{
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch{
                print("Response error")
                print(String(describing: error))
            }
            
            guard let result = json else{
                return
            }
            
            let current = result.current
            self.current = current
            print(result.current.temp)
            print(self.current!.temp)
        }).resume()
        
        print("\(lat) | \(long)")
    }
    
    struct WeatherResponse: Codable {
        let lat: Float
        let lon: Float
        let timezone: String
        let timezone_offset: Int
        let current: CurrentWeather
        let hourly: [HourlyWeather]
        let daily: [DailyWeather]
    }
    
    struct CurrentWeather: Codable{
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double
        let weather: [CurrWeatherInfo]
        let rain: CurrRainInfo?
        let snow: CurrSnowInfo?
    }
    
    //includes weather description and icon
    struct CurrWeatherInfo: Codable{
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    struct HourlyWeatherInfo: Codable{
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    struct DailyWeatherInfo: Codable{
        let id: Int
        let main: String
        let description: String
        let icon: String
    }


    enum CodingKeys: String, CodingKey{
        case Vol = "1h"
    }
    
    //optional rain and snow
    struct CurrRainInfo: Codable{
        
        let Vol: Double?
    }
    
    struct CurrSnowInfo: Codable{

        let Vol: Double?
    }
    
    struct HourlyWeather: Codable{
        let dt: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double
        let weather: [HourlyWeatherInfo]
        let pop: Double
    }
    
    struct DailyWeather: Codable{
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let moonrise: Int
        let moonset: Int
        let temp: DailyTemp
        let feels_like: DailyFeel
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let wind_speed: Double
        let wind_deg: Int
        let wind_gust: Double
        let weather: [DailyWeatherInfo]
        let cloud: Int?
        let pop: Double
        let rain: Double?
        let snow: Double?
        let uvi: Double
    }
    
    struct DailyTemp: Codable{
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    struct DailyFeel: Codable{
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    

}

