//
//  TechnieChatVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit

class TechnieChatVC: UIViewController {

    // MARK: - Properties

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        setupViews()
    }
    
    // MARK: - Methods
    func setupViews() {
        setupNavBar()
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationItem.title = "Messages"
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    // MARK: - Selectors

}
