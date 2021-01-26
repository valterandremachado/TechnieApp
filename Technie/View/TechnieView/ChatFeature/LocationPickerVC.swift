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
    
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    var dynamicHeightConstraint: NSLayoutConstraint?
    var directionsArray: [MKDirections] = []
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
//        map.layoutMargins = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: -100) // hides apple logo and legal label from the map
        return map
    }()

    lazy var addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .white
//        lbl.text = "Dummy text"
//        lbl.textColor = .red
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var pin: MKPointAnnotation = {
        let pin = MKPointAnnotation()
        pin.title = "Client's House"
        return pin
    }()
    
    lazy var handlerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var addressView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.roundTopLeftAndRightCorners(radius: 25)
      
        view.addSubview(handlerView)
        handlerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        handlerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        handlerView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        handlerView.heightAnchor.constraint(equalToConstant: 5).isActive = true
       
        return view
    }()
    
    
    // MARK: Inits
    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        self.isPickable = coordinates == nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        mapView.removeAnnotations(mapView.annotations)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        if isPickable {
            // Allow user to pick a location
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(sendButtonTapped))
            mapView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(didTapMap(_:)))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            mapView.addGestureRecognizer(gesture)
        } else {
            // Show location given by the user previously with a pin on it
            guard let coordinates = self.coordinates else { return }
            
            centerViewOnUserLocation()
            getDirections(savedCoordinate: coordinates)
            let locationCoordinate = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            reverseGeoLocationOfClient(locationCoordinate)
            mapView.showsUserLocation = true
            mapView.userLocation.title = "Me"
//            mapView.userTrackingMode = .follow
//            mapView.mapType = .mutedStandard
            // drop a pin on this location
            pin.coordinate = coordinates
            mapView.addAnnotation(pin)
        }
        centerViewOnUserLocation()
//        view.addSubview(mapView)
//        mapView.addSubview(addressLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dynamicHeightConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        removeMapMemoryWarning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("receiving memory warning...")
    }
    
    
    
    // MARK: Methods
    
    func removeMapMemoryWarning() {
        mapView.showsUserLocation = false
        mapView.delegate = nil
        locationManager.delegate = nil
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
  
    func setupViews() {
        view.addSubview(mapView)
        mapView.addSubview(addressView)
        addressView.addSubview(addressLabel)
        
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

        addressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        addressView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        dynamicHeightConstraint = addressView.heightAnchor.constraint(equalToConstant: 0)
        dynamicHeightConstraint?.isActive = true
        
        addressLabel.anchor(top: handlerView.topAnchor, leading: addressView.leadingAnchor, bottom: nil, trailing: addressView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 20))
        
    }
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func getDirections(savedCoordinate: CLLocationCoordinate2D) {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        
        let destinationCoordinate = savedCoordinate
        let request = createDirectionsRequest(from: location, destination: destinationCoordinate)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
//            let route = response.routes[0]
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
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
    var location2: CLLocationCoordinate2D?

    func centerViewOnUserLocation() {
        // Get user location then center map on the user location
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            location2 = location
        }
        
//        let geoCoder = CLGeocoder()
//        let clLocation = CLLocation(latitude: location2!.latitude, longitude: location2!.longitude)
//        geoCoder.reverseGeocodeLocation(clLocation) { [weak self] (placemarks, error) in
////            guard let self = self else { return }
//
//            if let _ = error {
//                //TODO: Show alert informing the user
//                return
//            }
//
//            guard let placemark = placemarks?.first else {
//                //TODO: Show alert informing the user
//                return
//            }
//
//            let streetNumber = placemark.subThoroughfare ?? ""
//            let streetName = placemark.thoroughfare ?? ""
//            let subLocality = placemark.subLocality ?? "" //Brgy
//
//            print("StreetNo: \(streetNumber), StreetName:\(streetName), Brgy:\(subLocality)")
//        }
        
    }
    
//    func fetchUserLocation(_ location: CLLocation) {
//        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
//                                                longitude: location.coordinate.longitude)
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.1,
//                                    longitudeDelta: 0.1)
//
//        let region = MKCoordinateRegion(center: coordinate,
//                                        span: span)
//
//        mapView.setRegion(region, animated: true)
//
////        let pin = MKPointAnnotation()
////        pin.coordinate = coordinate
////        map.addAnnotation(pin)
//    }
    
    func reverseGeoLocationOfClient(_ locationCoordinate: CLLocation) {
        let geoCoder = CLGeocoder()
//        let clLocation = CLLocation(latitude: location2!.latitude, longitude: location2!.longitude)
        geoCoder.reverseGeocodeLocation(locationCoordinate) { [weak self] (placemarks, error) in
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
            let subLocality = placemark.subLocality ?? "" //Brgy
            let streetNumberWithComma = !streetNumber.isEmpty ? ("\(streetNumber),") : ("")
            let streetNameWithComma = !streetName.isEmpty ? ("\(streetName),") : ("")
            
            self.pin.subtitle = "\(streetNumberWithComma) \(streetNameWithComma) \(subLocality)"
            print("StreetNo: \(streetNumber), StreetName:\(streetName), Brgy:\(subLocality)")
        }
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
        let locationInView = gesture.location(in: mapView)
        let coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
        self.coordinates = coordinates

        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        // drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
//        previousLocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)//getCenterLocation(for: map)

        let geoCoder = CLGeocoder()
        let clLocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(clLocation) { [weak self] (placemarks, error) in
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
            let subLocality = placemark.subLocality ?? "" //Brgy
//            let multipleInfo = "\(String(describing: placemark.name)), \(String(describing: placemark.administrativeArea)), \(String(describing: placemark.subAdministrativeArea)), \(String(describing: placemark.areasOfInterest)), \(String(describing: placemark.locality)), \(String(describing: placemark.subLocality)), \(String(describing: placemark.region)), \(String(describing: placemark.inlandWater))"
            let streetNumberWithComma = !streetNumber.isEmpty ? ("\(streetNumber),") : ("")
            let streetNameWithComma = !streetName.isEmpty ? ("\(streetName),") : ("")
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumberWithComma) \(streetNameWithComma) \(subLocality)"
                print("address: \(self.addressLabel.text ?? "")")// + multipleInfo)
            }
            
            if streetName.isEmpty && streetNumber.isEmpty && subLocality.isEmpty {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.dynamicHeightConstraint?.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.dynamicHeightConstraint?.constant = 108
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }

}

// MARK: CLLocationManagerDelegate Extension
extension LocationPickerVC: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first { //first or last
            locationManager.stopUpdatingLocation()
//            if isPickable {
//                fetchUserLocation()
//            } else {
//                fetchUserLocation()
//                print("false")
//            }
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
//    }
    
    
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
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let center = getCenterLocation(for: map)
//        let geoCoder = CLGeocoder()
//        guard let previousLocation = self.previousLocation else { return }
//
//        guard center.distance(from: previousLocation) > 50 else { return }
//        self.previousLocation = center
//
//        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
//            guard let self = self else { return }
//
//            if let _ = error {
//                //TODO: Show alert informing the user
//                return
//            }
//
//            guard let placemark = placemarks?.first else {
//                //TODO: Show alert informing the user
//                return
//            }
//
//            let streetNumber = placemark.subThoroughfare ?? ""
//            let streetName = placemark.thoroughfare ?? ""
//
//            DispatchQueue.main.async {
//                self.addressLabel.text = "\(streetNumber) \(streetName)"
//                print("address: \(self.addressLabel.text ?? "N/A")")
//            }
//        }
//    }
}
