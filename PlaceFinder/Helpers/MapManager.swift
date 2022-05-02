//
//  MapManager.swift
//  PlaceFinder
//
//  Created by Sergey on 02.05.2022.
//

import UIKit
import MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    
    private let regionInMeters = 500.0
    private var directionsArray: [MKDirections] = []
    private var placeCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Set the location and add annotation to the point
    func setupPlacemark(place: Place, mapView: MKMapView) {
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            } else {
                guard let placemarks = placemarks else { return }
                let placemark = placemarks.first
                
                let annotation = MKPointAnnotation()
                annotation.title = place.name
                annotation.subtitle = place.type
                
                guard let placemarkLocation = placemark?.location else { return }
                
                annotation.coordinate = placemarkLocation.coordinate
                self.placeCoordinate = placemarkLocation.coordinate
                
                mapView.showAnnotations([annotation], animated: true)
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    // checking access to geolocation services
    func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuth(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are disabled",
                               message: "to enable it go: Settings -> Privacy -> Location Services and turn on")
            }
        }
    }
    
    // verification of application authorization for geolocation tracking
    func checkLocationAuth(mapView: MKMapView, segueIdentifier: String) {
        switch CLLocationManager.authorizationStatus() {
        case .restricted:
                break
//                setupLocationManager()
        case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
                if segueIdentifier == "getAddress" { showUserLocation(mapView: mapView) }
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location is not availible",
                               message: "to enable it go: Settings -> Privacy -> Location Services and turn on")
                }
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
    
    // Map focus on the user's location
    func showUserLocation(mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Build a route from the user to the place
    
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> Void) {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        // tracking the user's current location
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionRequests(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        
        resetMapView(withNew: directions, mapView: mapView)
        
        directions.calculate { (response,error) in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available")
                return
            }
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime / 60
                
                print("Расстояние до места \(distance) км.")
                print("Время в пути \(timeInterval) мин.")
            }
        }
    }
    
    func createDirectionRequests(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // display the map area according to the user's movement
    func startTrackingUserLocation(for mapView: MKMapView,
                                   and location: CLLocation?,
                                   closure: (_ currentLocation: CLLocation) -> Void) {
        
        guard let previousLocation = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previousLocation) > 50 else { return }
       
        closure(center)
    }
    
    // resetting all previously built routes
    func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    // determining the center of the displayed area of the map
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }    
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
    }
}
