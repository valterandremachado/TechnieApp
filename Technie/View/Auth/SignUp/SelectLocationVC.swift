//
//  SelectLocationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/15/21.
//

import UIKit
import MapKit

// Singleton
protocol SelectedLocationDelegate: class {
    func fetchSelectedAddress(address: String, lat: Double, long: Double)
}

class SelectLocationVC: UIViewController {

    // MARK: - Properties
    weak var selectedLocationDelegate: SelectedLocationDelegate?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
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
        tv.register(SelectLocationCell.self, forCellReuseIdentifier: SelectLocationCell.cellID)
        return tv
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
   
        // Setup SearchBar
        let searchBar = search.searchBar
        searchBar.placeholder = "Search for location"
        searchBar.sizeToFit()
        searchBar.delegate = self
        // changes searchbar placeholder appearance
        let placeholderAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        placeholderAppearance.font = .systemFont(ofSize: 15)
        return search
    }()
    
    var matchingItems:[MKMapItem] = []
    let locationManager = CLLocationManager()

    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0) }
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Location"
    }

    func performSearchRequest(searchedLocation: String) {
        let request = MKLocalSearch.Request()
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        request.naturalLanguageQuery = "\(searchedLocation)"
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3200, longitudinalMeters: 3200)
        // about a couple miles around you
        
        print(request.region)
        
        MKLocalSearch(request: request).start { (response, error) in
            guard error == nil else { return }
            guard let response = response else { return }
            guard response.mapItems.count > 0 else { return }
            
            self.matchingItems = response.mapItems
            self.tableView.reloadData()

        }
    }
    
    // MARK: - Selectors

}

extension SelectLocationVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("error:: \(error.localizedDescription)")
    }
}

// MARK: - UISearchBarDelegate Extension
extension SelectLocationVC: UISearchBarDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        searchBar.text = searchText.lowercased()
        if searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            //            print("isEmpty")
        } else {
        }

        if searchText.isEmpty == false {
            performSearchRequest(searchedLocation: searchText)
        }

    }
    
  
}


// MARK: - TableViewDataSourceAndDelegate Extension
extension SelectLocationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SelectLocationCell.cellID, for: indexPath) as! SelectLocationCell
        cell = SelectLocationCell(style: .subtitle, reuseIdentifier: SelectLocationCell.cellID)
        
        let selectedItem = matchingItems[indexPath.row].placemark

        let name = selectedItem.name
//                let streetNumber = selectedItem.subThoroughfare ?? ""
//                let streetName = selectedItem.thoroughfare ?? ""
        let locality = selectedItem.locality ?? ""  //Brgy or neighborhood
        let subLocality = selectedItem.subLocality ?? ""  //Brgy or neighborhood
        
        let subLocalityWithComma = !subLocality.isEmpty ? ("\(subLocality),") : ("")
        let localityWithComma = !locality.isEmpty ? ("\(locality)") : ("")
        
        cell.detailTextLabel?.textColor = .systemGray
        cell.detailTextLabel?.text = "\(subLocalityWithComma) \(localityWithComma)"
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = matchingItems[indexPath.row].placemark
        let locality = selectedItem.locality ?? ""
        let subLocality = selectedItem.subLocality ?? ""  //Brgy or neighborhood
        let subLocalityWithComma = !subLocality.isEmpty ? ("\(subLocality),") : ("")
        let localityWithComma = !locality.isEmpty ? ("\(locality)") : ("")
//        print("coordinates: " ,selectedItem.coordinate, ", name: ", selectedItem.name)
        
        let lat = selectedItem.coordinate.latitude
        let long = selectedItem.coordinate.longitude
        let address = "\(subLocalityWithComma) \(localityWithComma)"
        
        selectedLocationDelegate?.fetchSelectedAddress(address: address, lat: lat, long: long)
        searchController.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    
}
