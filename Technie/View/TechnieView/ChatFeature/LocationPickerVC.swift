//
//  LocationPickerVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/21/21.
//

import UIKit
import CoreLocation
import MapKit

final class LocationPickerVC: UIViewController {

    // MARK: Properties
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private var isPickable = true
    private let locationManager = CLLocationManager()
    private lazy var map: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        return map
    }()

    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    lazy var addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .cyan
//        lbl.text = "Dummy text"
        lbl.textColor = .red
        lbl.textAlignment = .center
        return lbl
    }()
    
    var directionsArray: [MKDirections] = []

    // MARK: Inits
    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        self.isPickable = coordinates == nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if isPickable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(sendButtonTapped))
            map.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(didTapMap(_:)))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            map.addGestureRecognizer(gesture)
        } else {
            // just showing location
            guard let coordinates = self.coordinates else { return }
            
//            centerViewOnUserLocation()
            getDirections()
            
            map.showsUserLocation = true
            map.userLocation.subtitle = "Me"
            
            // drop a pin on that location
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            pin.title = "Client's House"
            map.addAnnotation(pin)
        }
        view.addSubview(map)
        map.addSubview(addressLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
//        addressLabel.isHidden = true
        addressLabel.withHeight(50)
        addressLabel.anchor(top: nil, leading: map.leadingAnchor, bottom: map.bottomAnchor, trailing: map.trailingAnchor)
    }
    
    // MARK: Methods
    func resetMapView(withNew directions: MKDirections) {
        map.removeOverlays(map.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        
        guard let destinationCoordinate = coordinates else { return }
        let request = createDirectionsRequest(from: location, destination: destinationCoordinate)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
//            let route = response.routes[0]
//            print("response: \(response)")
            for route in response.routes {
                self.map.addOverlay(route.polyline)
                self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = destination
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .systemBlue
        return render
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    func fetchUserLocation(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        map.setRegion(region, animated: true)

//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinate
//        map.addAnnotation(pin)
    }
    
    func fetchUserLocation() {
        guard let coordinate = self.coordinates else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        map.setRegion(region, animated: true)

//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinate
//        map.addAnnotation(pin)
    }
    
    // MARK: Selectors
    @objc func sendButtonTapped() {
        guard let coordinates = coordinates else {
            return
        }
        navigationController?.popViewController(animated: true)
        completion?(coordinates)
    }

    @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates

        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
        
        // drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
        previousLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)//getCenterLocation(for: map)
    }

}

// MARK: CLLocationManagerDelegate Extension
extension LocationPickerVC: CLLocationManagerDelegate {
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first { //first or last
//            locationManager.stopUpdatingLocation()
//            if isPickable {
//                fetchUserLocation()
//            } else {
//                fetchUserLocation()
//                print("false")
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationAuthorization()
//    }
}

// MARK: MKMapViewDelegate Extension
extension LocationPickerVC: MKMapViewDelegate {
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: map)
        let geoCoder = CLGeocoder()
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
                print("address: \(self.addressLabel.text ?? "N/A")")
            }
        }
    }
}
