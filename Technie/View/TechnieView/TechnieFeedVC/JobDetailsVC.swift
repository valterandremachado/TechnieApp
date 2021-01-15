//
//  JobDetailsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/15/21.
//

import UIKit

class JobDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        setupNavBar()
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.topItem?.title = "Job Details"
        navigationItem.title = "Job Details"
        navigationItem.largeTitleDisplayMode = .never
    }
}
