//
//  ProofOfExpertiseVC.swift
//  Technie
//
//  Created by Valter A. Machado on 4/30/21.
//

import UIKit
import SDWebImage

class ProofOfExpertiseVC: UIViewController {
    
    var proofOfExpertiseUrl = ""
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Proof of Expertise"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.sd_setImage(with: URL(string: proofOfExpertiseUrl), completed: nil)
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissVC))
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    

}
