//
//  ClientChatVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit

class ClientChatVC: UIViewController {
    
    // MARK: - Properties
//    lazy var searchBar: UISearchBar = {
//        let sb = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
//        sb.placeholder = "Search"
//        sb.tintColor = .systemPink
//        //sb.backgroundColor = .white
////        sb.delegate = self
//        return sb
//    }()
    
    var searchController: UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search"
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.sizeToFit()
        return search
    }
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupNavBar()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        
    }
    
    fileprivate func setupNavBar() {
        guard let nav = navigationController?.navigationBar else { return }
        nav.prefersLargeTitles = true
        navigationItem.title = "Messages"
//        let rightNavBarButton = UIBarButtonItem(customView: searchBar)
//        navigationItem.rightBarButtonItem = rightNavBarButton
        navigationItem.searchController = searchController
    }
    
    // MARK: - Selectors

}
