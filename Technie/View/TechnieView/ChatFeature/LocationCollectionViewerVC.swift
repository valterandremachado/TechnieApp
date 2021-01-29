//
//  LocationCollectionViewerVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/29/21.
//

import UIKit
import CoreLocation

class LocationCollectionViewerVC: UIViewController {

    var convoSharedLocationArray = [String]()
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false

        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(LocationCollectionViewerCell.self, forCellReuseIdentifier: LocationCollectionViewerCell.cellID)
        return tv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
    }

    // MARK: - Methods
    func setupViews() {
        title = "Shared Locations"
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    // MARK: - Selectors

}

// MARK: - Extension
extension LocationCollectionViewerVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convoSharedLocationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: LocationCollectionViewerCell.cellID, for: indexPath) as! LocationCollectionViewerCell
        cell = LocationCollectionViewerCell(style: .subtitle, reuseIdentifier: LocationCollectionViewerCell.cellID)
        

        cell.textLabel?.text = "Location \(indexPath.row + 1)"
        
        // TODO: Divide lat and long inside the string array
        let delimiter = ","
        let token = convoSharedLocationArray[indexPath.row].components(separatedBy: delimiter)
        // TODO: Convert lat and long string to double
        let lat = Double(token[1]) ?? 401
        let long = Double(token[0]) ?? 400
        // TODO: Convert lat and long into geoLocation
        let geoCoder = CLGeocoder()
        let locationCoordinate = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(locationCoordinate) { (placemarks, error) in
            if let _ = error { return }
            guard let placemark = placemarks?.first else { return }

            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let subLocality = placemark.subLocality ?? ""// brgy
            let streetNumberWithComma = !streetNumber.isEmpty ? ("\(streetNumber),") : ("")
            let streetNameWithComma = !streetName.isEmpty ? ("\(streetName),") : ("")
            let location = "\(streetNumberWithComma) \(streetNameWithComma) \(subLocality)"
            let locationWithNoLeftAndRightWhiteSpace = location.trimmingCharacters(in: .whitespaces)
            cell.detailTextLabel?.textColor = .systemGray
            cell.detailTextLabel?.text = locationWithNoLeftAndRightWhiteSpace
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Divide lat and long inside the string array
        let delimiter = ","
        let token = convoSharedLocationArray[indexPath.row].components(separatedBy: delimiter)
        // TODO: Convert lat and long string to double
        let lat = Double(token[1]) ?? 401
        let long = Double(token[0]) ?? 400
        // TODO: Convert lat and long into geoLocation
        let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let vc = LocationPickerVC(coordinates: locationCoordinate)
        vc.title = "Client's Location"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
