//
//  RankedTechnieVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/19/20.
//

import UIKit

class RankedTechnieVC: UIViewController {
    // MARK: - Properties
    var stringPrint = ""
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        print("stringPrint: "+stringPrint)
        setupNavBar()
    }

    // MARK: - Methods
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.hideNavBarSeperator()

//        navBar.topItem?.title = "Add Skills"
//        navBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
        let leftNavBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(leftNavBarBtnTapped))
            //UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftNavBarBtnTapped))

        self.navigationItem.leftBarButtonItem = leftNavBarButton
//        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
}
