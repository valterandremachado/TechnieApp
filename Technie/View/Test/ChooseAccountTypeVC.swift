//
//  ChooseAccountTypeVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/20/21.
//

import UIKit

class ChooseAccountTypeVC: UIViewController {

    lazy var signupAsClientBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Signup as Client", for: .normal)
        btn.backgroundColor = .systemPink
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(clientBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var signupAsTecnicianBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Signup as Technician", for: .normal)
        btn.backgroundColor = .systemPink
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(technicianBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [signupAsClientBtn, signupAsTecnicianBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalSpacing
        return sv
    }()
    
    var pickAccountType = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        
        navigationItem.title = "Test"
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: 200),
            mainStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func technicianBtnPressed() {
        pickAccountType = 0
        let vc = LoginOrSignupVC()
        vc.pickAccountType = pickAccountType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clientBtnPressed() {
        pickAccountType = 1
        let vc = LoginOrSignupVC()
        vc.pickAccountType = pickAccountType
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
