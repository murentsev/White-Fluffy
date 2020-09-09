//
//  CollectionViewCell.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 08.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import UIKit
import WebKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var partName: UILabel!
    @IBOutlet weak var web: WKWebView!
    @IBOutlet weak var degree: UILabel!
    
    func configure(part: WeatherHour) {
        if String(part.hour).count == 1 {
            partName.text = "0\(String(part.hour)):00"
        } else {
            partName.text = "\(String(part.hour)):00"
        }
        degree.text = String(part.temp) + " °C"
        let htmlContent = "<img src=\"https://yastatic.net/weather/i/icons/blueye/color/svg/\(part.icon).svg\" style=\"margin: auto; height: 100%\" />"
        web.loadHTMLString(htmlContent, baseURL: Bundle.main.bundleURL)
    }
}
