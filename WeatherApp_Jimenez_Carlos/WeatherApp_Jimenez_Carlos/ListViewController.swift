//
//  ListViewController.swift
//  WeatherApp_Jimenez_Carlos
//
//  Created by Carlos Jimenez on 11/15/21.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet var WeatherListCollectView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherListCollectView.delegate = self
        WeatherListCollectView.dataSource = self
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    

    
    
    
  
    
    
    //Temporary
    @IBAction func DismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        return cell
    }
    
}

extension ListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 374, height: 163)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}




