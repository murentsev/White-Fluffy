//
//  TableViewCell.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 07.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import UIKit
import Kingfisher
import WebKit


class TableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var degree: UILabel!
    
    @IBOutlet weak var web: WKWebView!
 
    
    
    func configure(city: TableData) {
        cityName.text = String(city.city.url)
        degree.text = String(city.degree) + " °C"
        let htmlContent = "<img src=\"https://yastatic.net/weather/i/icons/blueye/color/svg/\(city.icon).svg\" style=\"margin: auto; height: 100%\" />"
        web.loadHTMLString(htmlContent, baseURL: Bundle.main.bundleURL)
        selectionStyle = .none
    }
    
   

}
