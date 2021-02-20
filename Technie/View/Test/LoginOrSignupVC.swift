//
//  LoginOrSignupVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/20/21.
//

import UIKit

class LoginOrSignupVC: UIViewController {

    lazy var signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Signup", for: .normal)
        btn.backgroundColor = .systemPink
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(signupBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemPink
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [loginBtn, signupBtn])
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
        view.backgroundColor = .white
        
        pickAccountType == 0 ? (navigationItem.title = "Technician Account") : (navigationItem.title = "Client Account")
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: 200),
            mainStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func signupBtnPressed() {
        let vc = SignupVC()
        vc.pickAccountType = pickAccountType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginBtnPressed() {
        let vc = LoginVC()
        vc.pickAccountType = pickAccountType
        navigationController?.pushViewController(vc, animated: true)
    }
}
