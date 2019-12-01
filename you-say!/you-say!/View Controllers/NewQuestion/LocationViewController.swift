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

class LocationViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    // MARK: Core Location
    
    var locationManager = CLLocationManager()
    var selectedCoordinate: CLLocationCoordinate2D!
    var findLocation = false
    
    
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
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
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
    
    
    // MARK: - Actions
    
    /**
     Locates the user on the map.
     */
    @IBAction func findCurrentLocation(_ sender: UIButton) {
        // Verificate permissions
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            showAlert(
                title: "Debes habilitar la localización",
                message: "No se pudo localizarte"
            )
            return
        }
        
        // Locate
        self.findLocation = true
        self.locationManager.requestLocation()
    }
    

    // MARK: - Navigation

    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Verificate permissions
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            showAlert(
                title: "Debes habilitar la localización",
                message: "Son necesarios para crear una pregunta"
            )
            return
        }
        
        switch segue.identifier {
        case "createSegue":
            // Get parent controller
            guard let navigationVC = self.tabBarController as? NavigationViewController else { return }
            
            // Pass data to destination
            let createVC = segue.destination as! CreateQuestionViewController
            createVC.currentUser = navigationVC.currentUser
            createVC.categories = navigationVC.categories
            createVC.selectedCoordinate = self.selectedCoordinate
            
        default:
            return
        }
    }

}

// MARK: - CoreLocation Delegate

extension LocationViewController: CLLocationManagerDelegate {
    
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
        showAlert(
            title: "No se pudo calcular tu ubicación",
            message: "Asegúrate de habilitar el GPS y de dar permisos"
        )
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
            
            // Show
            zoomToLocation(coordinate: self.selectedCoordinate)
            addAnnotation(coordinate: location.coordinate, title: "Ubicación inicial")
            
        } else if self.findLocation, let location = locations.last {
            // Update position
            self.selectedCoordinate = location.coordinate
            self.findLocation = false
            
            // Show
            zoomToLocation(coordinate: self.selectedCoordinate)
            addAnnotation(coordinate: location.coordinate, title: "Ubicación actual")
        }
    }
    
    /**
     Shows the selected coordinate in the map.
     
     - Parameter coordinate: Coordinate to zoom in.
     */
    private func zoomToLocation(coordinate: CLLocationCoordinate2D) {
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
}

// MARK: - MapKit Delegate

extension LocationViewController: MKMapViewDelegate {
    
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
