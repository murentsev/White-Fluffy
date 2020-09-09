//
//  WeatherTableViewCell.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 08.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var partsOfDay: [WeatherHour] = []
    
    func configure(city: Forecast) {

        self.date.text = city.date
        self.partsOfDay = city.hours
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}

extension WeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return partsOfDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.configure(part: partsOfDay[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3,
        height: collectionView.bounds.width / 1)
    }
    
    
    
}
