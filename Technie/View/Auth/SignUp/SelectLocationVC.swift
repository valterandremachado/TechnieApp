//
//  SelectLocationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/15/21.
//

import UIKit

class SelectLocationVC: UIViewController {

    // MARK: - Properties
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
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
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
    
    // MARK: - Selectors

}

// MARK: - UISearchBarDelegate Extension
extension SelectLocationVC: UISearchBarDelegate {
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.searchTextField.autocapitalizationType = .none
//        guard let searchedString = searchBar.text else { return }
//        presentSearchResults(searchedString, filteredData)
//    }
////    func presentSearchController(_ searchController: UISearchController) {
////        searchController.searchBar.becomeFirstResponder()
////    }
//
//    fileprivate func presentSearchResults(_ searchedString: String,_ filteredTechnicians: [TechnicianModel]) {
//        let vc = TechnicianSearchResultsVC()
//        vc.title = "\(searchedString) results".lowercased()
//        vc.technicianModel = filteredTechnicians
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //        searchBar.text = searchText.lowercased()
//        if searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//            //            print("isEmpty")
//        } else {
//        }
//
//        if searchText.isEmpty == false {
////            let skills = technicianModel.profileInfo.skills
////            let flatStrings = skills.joined(separator: ", ")
//            if searchText != "," {
//                guard !searchText.replacingOccurrences(of: " ", with: "").isEmpty else { return }
//                filteredData = technicianModel
//                let filteredArray = technicianModel.filter { (technician) -> Bool in
//                    return technician.profileInfo.name.localizedCaseInsensitiveContains(searchText) || technician.profileInfo.skills.joined(separator: ", ").localizedCaseInsensitiveContains(searchText) }
//                filteredData = filteredArray//technicianModel.filter({ $0.profileInfo.skills.joined(separator: ", ").localizedCaseInsensitiveContains(searchText) })
//                print(filteredArray)
//            }
//
//        }
//
//    }
    
  
}


// MARK: - TableViewDataSourceAndDelegate Extension
extension SelectLocationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectLocationCell.cellID, for: indexPath) as! SelectLocationCell
        cell.textLabel?.text = "test"
        return cell
    }
    
    
}
