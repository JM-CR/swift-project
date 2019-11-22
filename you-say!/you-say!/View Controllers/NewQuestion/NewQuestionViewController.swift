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

class NewQuestionViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties

    var selectedCoordinate: CLLocationCoordinate2D!
    
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
        setupGestures()
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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        // Zoom to user location
        if CLLocationManager.authorizationStatus().rawValue == 4 {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    /**
     Add gestures to the mapView.
     */
    private func setupGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPin))
        self.mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: Gestures
    
    /**
     Adds an annotation where the user taps.
     */
    @objc private func addPin(sender: UILongPressGestureRecognizer) {
        // Get coordinate
        let location = sender.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        // Add annotation
        addAnnotation(coordinate: coordinate, title: "Nueva ubicación")
        
        // Update position
        self.selectedCoordinate = coordinate
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

// MARK: - CoreLocation Delegate

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
     Shows the initial position of the user in the map.
     
     - Parameter manager: Location manager object.
     - Parameter locations: Tracking history.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 1, let location = locations.last {
            // Update position
            self.selectedCoordinate = location.coordinate
            
            // Zoom to position
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: center, span: span)
            self.mapView.setRegion(region, animated: true)
            
            // Add annotation
            addAnnotation(coordinate: location.coordinate, title: "")
        }
    }
    
}

// MARK: - MapKit Delegate

extension NewQuestionViewController: MKMapViewDelegate {
    
    /**
     Adds an annotation at the given coordinate.
     
     - Parameter coordinate: Location of the annotation.
     - Parameter title: Title for the annotation.
     */
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String) {
        // Remove previous
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // Add new
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
    }
    
}
