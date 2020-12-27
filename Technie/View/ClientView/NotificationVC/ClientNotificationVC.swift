//
//  ClientNotificationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit

class ClientNotificationVC: UIViewController {

    // MARK: - Properties
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        setupNavBar()
    }
   
    // MARK: - Methods
    fileprivate func setupViews() {
        
    }
    
    fileprivate func setupNavBar() {
        guard let nav = navigationController?.navigationBar else { return }
        nav.prefersLargeTitles = true
        navigationItem.title = "Notifications"
    }
    
    // MARK: - Selectors

}
