//
//  NewQuestionViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewQuestionViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    // MARK: Core Location
    
    var locationManager = CLLocationManager()
    
    
    // MARK: - View Life Cycle
    
    /**
     Initial setup for the controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
        setupDelegates()
        setupLocation()
    }
    
    // MARK: Setup
    
    /**
     Current delegates for the view controller.
     */
    private func setupDelegates() {
        self.locationManager.delegate = self
        self.mapView.delegate = self
    }
    
    /**
     Prepares location services.
     */
    private func setupLocation() {
        // Core Location
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        // Zoom to user location
        if CLLocationManager.authorizationStatus().rawValue == 4 {
            self.locationManager.startUpdatingLocation()
        }
    }
    

    // MARK: - Navigation

    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

// MARK: - Core Location Delegate

extension NewQuestionViewController: CLLocationManagerDelegate {
    
    /**
     Starts or stops tracking the user when authorization status changes.
     
     - Parameter manager: Location manager object.
     - Parameter status: Given permissions.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        default:
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    /**
     Alert when tracking fails.
     
     - Parameter manager: Location manager object.
     - Parameter error: Status error.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Format error
        let strError = "Error \((error as NSError).code): \(error.localizedDescription)"
        
        // Alert with the error
        showAlert(title: "No se pudo calcular tu ubicación", message: strError)
    }
    
    /**
     Shows the current position of the user in the map.
     
     - Parameter manager: Location manager object.
     - Parameter locations: Tracking history.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: center, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
}
