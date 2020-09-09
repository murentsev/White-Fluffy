//
//  MapViewController.swift
//  White&Fluffy
//
//  Created by Алексей Муренцев on 07.09.2020.
//  Copyright © 2020 Алексей Муренцев. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    let annotationIdentifire = "annotationIdentifire"
    let locationManager = CLLocationManager()
    var lat: String = ""
    var lon: String = ""
    var name: String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var adressField: UITextField!
    @IBAction func findAdress(_ sender: Any) {
        setupPlacemark()
    }
    @IBAction func centerViewInUserLocation(_ sender: Any) {
        adressField.text = ""
        centerUserLocation()
    }
    @IBAction func done(_ sender: Any) {
        showAleryCityName()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        centerUserLocation()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    private func setupPlacemark() {
        guard let adress = adressField.text else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adress) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            
            guard let placemarkLocation = placemark?.location else { return }
            let region = MKCoordinateRegion(center: placemarkLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            annotation.coordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Ваша геопозиция неопределена", message: "Необходимо дать разрешение на определение местоположения")
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Ваша геопозиция неопределена", message: "Необходимо дать разрешение на определение местоположения")
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case")
        }
    }
    
    private func centerUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAleryCityName() {
    let alert = UIAlertController(title: "Введите наименование для этого места", message: "Это имя буде отображаться в общем списке погоды", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.adressField.text!.isEmpty ? "" : self.adressField.text
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.name = textField?.text as! String
            self.performSegue(withIdentifier: "back", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
                 
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        self.lat = String(center.coordinate.latitude)
        self.lon = String(center.coordinate.longitude)
    }
}
