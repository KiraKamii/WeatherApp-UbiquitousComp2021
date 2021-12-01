//
//  ListViewController.swift
//  WeatherApp_Jimenez_Carlos
//
//  Created by Carlos Jimenez on 11/15/21.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet var WeatherListCollectView: UICollectionView!
    
    var currListWeather = ListWeather(currentTemp: 0, currentCity: "", currentDescrip: "", currentHi: 0, currentLo: 0)
    var savedListWeather = ListWeather(currentTemp: 0, currentCity: "", currentDescrip: "", currentHi: 0, currentLo: 0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherListCollectView.delegate = self
        WeatherListCollectView.dataSource = self
        // Do any additional setup after loading the view.
        //print(currentTime(timeZoneIdentifier: "CST")!) //2019-11-20 23:37:28 091

        
    }
    
    func currentTime(timeZoneIdentifier: String) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        
        return dateFormatter.string(from: Date())
    }
    

}

//Table of saved weather forecasts
extension ListViewController: UICollectionViewDelegate{
    
}
extension ListViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = WeatherListCollectView.dequeueReusableCell(withReuseIdentifier: "Weather_Cell", for: indexPath)
        
        //Update Weather cells
        let cellCurrTemp = cell.viewWithTag(1) as! UILabel
        cellCurrTemp.text = "\(currListWeather.currentTemp)°"
        
        let cellCurrCity = cell.viewWithTag(2) as! UILabel
        cellCurrCity.text = currListWeather.currentCity

        let cellCurrDescrip = cell.viewWithTag(3) as! UILabel
        cellCurrDescrip.text = currListWeather.currentDescrip
        
        let cellCurrHi = cell.viewWithTag(4) as! UILabel
        cellCurrHi.text = "H: \(currListWeather.currentHi)°"
        
        let cellCurrLow = cell.viewWithTag(5) as! UILabel
        cellCurrLow.text = "L: \(currListWeather.currentLo)°"
        
        if indexPath.item == 1 {
            
            let cellW2City = cell.viewWithTag(6) as!UILabel
            cellW2City.text = savedListWeather.currentCity
            cellCurrTemp.text = "\(savedListWeather.currentTemp)°"
            //time instead of city
            cellCurrCity.text = currentTime(timeZoneIdentifier: "CST")
            cellCurrDescrip.text = savedListWeather.currentDescrip
            cellCurrHi.text = "H: \(savedListWeather.currentHi)°"
            cellCurrLow.text = "L: \(savedListWeather.currentLo)°"

        }

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            performSegue(withIdentifier: "ListToWeather2", sender: self)
            self.dismiss(animated: false, completion: nil)

        }else if indexPath.item == 0 {
            performSegue(withIdentifier: "ListToWeather", sender: self)
            self.dismiss(animated: false, completion: nil)

        }
    }
    
}

extension ListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 330, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}




