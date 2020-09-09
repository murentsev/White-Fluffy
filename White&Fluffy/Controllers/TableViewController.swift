//
//  TableViewController.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 07.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    lazy var service = WeatherService()
    lazy var realm = try! Realm()
    var notificationToken: NotificationToken?
    var citiesResult: Results<City>!
    
    var cities: [City] = []
    var items: [TableData] = []
    var itemsForSearch: [TableData] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "back" else { return }
        guard let svc = segue.source as? MapViewController else { return }
        let lat = svc.lat
        let lon = svc.lon
        let cityName = svc.name
        service.getCity(lat: lat, lon: lon, setName: cityName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        subscribeToNotifications()
        LoadFromNetwork()
    }
    
    private func subscribeToNotifications() {
        citiesResult = realm.objects(City.self)
        notificationToken = citiesResult.observe {[weak self] (changes) in
            switch changes {
            case .initial(let citiesResult):
                self?.cities = Array(citiesResult)
                self?.LoadFromNetwork()
                self?.tableView.reloadData()
            case .update(let citiesResult, _, _, _):
                self?.cities = Array(citiesResult)
                self?.LoadFromNetwork()
                self?.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }
    
    private func LoadFromNetwork() {
        self.items.removeAll()
        self.itemsForSearch.removeAll()
        for city in cities {
            service.getFactWeather(lat: String(city.lat), lon: String(city.lon)) {[weak self] (item: FactWeather) in
                self?.items.append(TableData(city: city, degree: item.temp, icon: item.icon))
                self?.itemsForSearch.append(TableData(city: city, degree: item.temp, icon: item.icon))
                self?.tableView.reloadData()
            }
        }
    }
    
    private func deleteCity(city: TableData) {
        try! realm.write {
            realm.delete(city.city)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.configure(city: items[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCity(city: items[indexPath.row])
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let controller = segue.destination as? WeatherTableViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            controller.cityLat = String(items[indexPath.row].city.lat)
            controller.cityLon = String(items[indexPath.row].city.lon)
            controller.name = items[indexPath.row].city.url
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        items = itemsForSearch
        if !searchText.isEmpty {
            items = items.filter({ $0.city.url.lowercased().contains(searchText.lowercased()) })
        }
        tableView.reloadData()
    }
    
}
