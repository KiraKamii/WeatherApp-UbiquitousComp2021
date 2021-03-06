//
//  SavedWeatherViewController.swift
//  WeatherApp_Jimenez_Carlos
//
//  Created by Carlos Jimenez on 11/30/21.
//

import UIKit
import CoreLocation



class SavedWeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    var currListWeather = ListWeather(currentTemp: 0, currentCity: "", currentDescrip: "", currentHi: 0, currentLo: 0)
    var savedListWeather = ListWeather(currentTemp: 0, currentCity: "", currentDescrip: "", currentHi: 0, currentLo: 0)

    let locationManager = CLLocationManager()

    //Current Forecast Header
    @IBOutlet weak var CurrTempLbl: UILabel!
    @IBOutlet weak var CurrCityLbl: UILabel!
    @IBOutlet weak var CurrDescripLbl: UILabel!
    @IBOutlet weak var DailyHighLbl: UILabel!
    @IBOutlet weak var DailyLowLbl: UILabel!
    
    //Hourly weather collection view
    @IBOutlet var HourlyCollectView: UICollectionView!
    
    //Daily weather table view
    @IBOutlet var DailyTableView: UITableView!
    
    //Details boxes
    @IBOutlet weak var WindSpeed: UILabel!
    @IBOutlet weak var WindDirection: UILabel!
    @IBOutlet weak var FeelsLikeTemp: UILabel!
    @IBOutlet weak var CloudPerc: UILabel!
    @IBOutlet weak var HumidityPerc: UILabel!
    
    var currentLocation: CLLocation?
    var currentCity = "Dallas"
    var daily = [DailyWeather]()
    var hourly = [HourlyWeather]()
    var current: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
        
    //swipe gesture
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
//        if sender.direction == .left
//        {
//           print("Swipe left")
//           // show the view from the right side
//        }

        if sender.direction == .right
        {
           print("Swipe right")
           // show the view from the left side
            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "W2toW1", sender: self)
            

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        
    }
    
    //Time and Day Conversions
    func getTime(dt: Int) -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(dt))
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h a"
        timeFormatter.timeZone = NSTimeZone() as TimeZone
        let localTime = timeFormatter.string(from: time)
        //print(localTime)
        return localTime
    }
    
    func getDay(dt: Int) -> String{
        let day = Date(timeIntervalSince1970: TimeInterval(dt))
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E"
        dayFormatter.timeZone = NSTimeZone() as TimeZone
        let dailyDay = dayFormatter.string(from: day)
        
        return dailyDay
    }

    
    //list button
    @IBAction func ListButton(_ sender: Any) {
        print("List")
        performSegue(withIdentifier: "Weather2ToList", sender: self)
    }
    
    //Update UI with json data
    func UpdateUI(){
        HourlyCollectView.delegate = self
        HourlyCollectView.dataSource = self
        
        DailyTableView.delegate = self
        DailyTableView.dataSource = self

        //Current Header
        savedListWeather = ListWeather(currentTemp: Int(self.current!.temp), currentCity: self.currentCity, currentDescrip: self.current!.weather[0].description.capitalized, currentHi: Int(daily[0].temp.max), currentLo: Int(daily[0].temp.min))
        self.CurrTempLbl.text = "\(Int(self.current!.temp))??"
        self.CurrCityLbl.text = self.currentCity
        self.CurrDescripLbl.text = self.current!.weather[0].description.capitalized
        self.DailyHighLbl.text = "H: \(Int(daily[0].temp.max))??"
        self.DailyLowLbl.text = "L: \(Int(daily[0].temp.min))??"
        
        //More Details
        self.WindSpeed.text = "\(Int(self.current!.wind_speed)) mph"
        self.WindDirection.text = "\(Direction(self.current!.wind_deg))"
        self.FeelsLikeTemp.text = "\(Int(self.current!.feels_like))??"
        self.CloudPerc.text = "\(self.current!.clouds) %"
        self.HumidityPerc.text = "\(self.current!.humidity) %"


    }
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Weather2ToList"{
            let ListViewController = segue.destination as! ListViewController
            ListViewController.currListWeather = currListWeather
            ListViewController.savedListWeather = savedListWeather
        }
        if segue.identifier == "W2toW1"{
            let CurrentWeatherViewController = segue.destination as! CurrentWeatherViewController
            CurrentWeatherViewController.savedListWeather = savedListWeather
        }
            
    }

    //Location Code
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus == .denied {
            let error = UIAlertController(title: "Location Use Was Not Allowed", message: "Your location is needed to provide local weather.", preferredStyle: .alert)
            error.addAction(UIAlertAction(title: "Okay", style: .cancel))
            present(error, animated: true)
        }
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
        //let long = currentLocation.coordinate.longitude
        //let lat = currentLocation.coordinate.latitude

        //***Dallas placeholder
        let lat = 32.7767
        let long = -96.7970
        
        // reverse geocode
        CLGeocoder().reverseGeocodeLocation(currentLocation) {(placemarks, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            if (placemarks?[0]) != nil {
                //print(place.locality!)
                //let city = place.locality!
                
                //***Dallas placeholder
                print("Dallas")
                self.currentCity = "Dallas"
            }
        }
       
        
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
            
            //store current weather data
            let current = result.current
            self.current = current
            
            let daily = result.daily
            self.daily.append(contentsOf: daily)
            
            let hourly = result.hourly
            self.hourly.append(contentsOf: hourly)
                        
            //print(result.current.temp)
            //print(self.currWeatherInfo)
            
            //Update UI
            DispatchQueue.main.async {
                self.UpdateUI()
            }
        }).resume()
        
        print("\(lat) | \(long)")
    }
    
    //JSON response
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
        let wind_deg: Float
        let wind_gust: Double?
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
        let wind_gust: Double?
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
        let wind_gust: Double?
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


//Hourly Collection View
extension SavedWeatherViewController: UICollectionViewDelegate{
    
}
extension SavedWeatherViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HourlyCollectView.dequeueReusableCell(withReuseIdentifier: "Hourly_Cell", for: indexPath)
        
        //Update Hourly cells
        let cellHour = cell.viewWithTag(1) as! UILabel
        
        if(indexPath.row == 0){
            cellHour.text = "Now"
        }else {
            cellHour.text = "\(getTime(dt: hourly[indexPath.row].dt))"
        }
        
        let cellIcon = cell.viewWithTag(2) as! UIImageView
        cellIcon.image = UIImage(named: "\(hourly[indexPath.row].weather[0].icon).png")
        
        let cellTemp = cell.viewWithTag(3) as! UILabel
        cellTemp.text = "\(Int(hourly[indexPath.row].temp))??"

        
        
        return cell
    }
    
}

extension SavedWeatherViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 108)
    }
}

// Ten Day Table View

extension SavedWeatherViewController: UITableViewDelegate{
    
}

extension SavedWeatherViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DailyTableView.dequeueReusableCell(withIdentifier: "Daily_Cell", for: indexPath)
        
        //Update Daily cells
        if(indexPath.row > daily.count-1){
            return UITableViewCell()
        }
        else{
        let cellDay = cell.viewWithTag(1) as! UILabel
            if(indexPath.row == 0){
                cellDay.text = "Today"
            }else{
                cellDay.text = "\(getDay(dt: daily[indexPath.row].dt))"
            }
        
        let cellIcon = cell.viewWithTag(2) as! UIImageView
        cellIcon.image = UIImage(named: "\(daily[indexPath.row].weather[0].icon).png")
        
        let cellLowTemp = cell.viewWithTag(3) as! UILabel
        cellLowTemp.text = "L: \(Int(daily[indexPath.row].temp.min))??"
        
        let cellHiTemp = cell.viewWithTag(4) as! UILabel
        cellHiTemp.text = "H: \(Int(daily[indexPath.row].temp.max))??"

        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    
}





