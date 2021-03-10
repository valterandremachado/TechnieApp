//
//  ExpertiseVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/11/21.
//

import UIKit

class ExpertiseVC: UIViewController {

    // MARK: - Properties
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        setupViews()
    }
    
    // MARK: - Methods
    private func setupViews() {
        [].forEach {view.addSubview($0)}

        setupNavBar()
    }
    
    private func setupNavBar() {
        
    }
    
}
