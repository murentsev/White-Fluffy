//
//  WeatherTableViewController.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 08.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    var service = WeatherService()
    var city: [Forecast] = []
    var cityLat: String = ""
    var cityLon: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        service.getForecast(lat: cityLat, lon: cityLon) {[weak self] (items: [Forecast]) in
            self?.city = items
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return city.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        cell.configure(city: city[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 254
    }
    
}
