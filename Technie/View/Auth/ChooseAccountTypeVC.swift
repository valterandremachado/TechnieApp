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
        btn.setTitle("I am a Client", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        btn.backgroundColor = .systemPink
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(clientBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var signupAsTecnicianBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("I am a Technician", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)

        //        btn.backgroundColor = .systemPink
        btn.tintColor = .systemPink
        btn.backgroundColor = .clear
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = .init(srgbRed: 255/255, green: 55/255, blue: 95/255, alpha: 1)
        btn.layer.borderWidth = 1
        
        btn.addTarget(self, action: #selector(technicianBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Best way to look for nearby technician!"
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textAlignment = .center
//        lbl.backgroundColor = .brown
        return lbl
    }()
    
    lazy var logoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.font = .boldSystemFont(ofSize: 30)
        lbl.textAlignment = .center
//        lbl.backgroundColor = .brown
        return lbl
    }()
    
    lazy var illustrationView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "technicians")
//        imageView.layer.cornerRadius = 20
        imageView.round(with: .both, radius: 20)
        imageView.addSubview(logoLabel)
        logoLabel.anchor(top: imageView.topAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        return imageView
    }()
    
    lazy var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true

        view.round(with: .both, radius: 20)
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [signupAsClientBtn, signupAsTecnicianBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 15
        sv.distribution = .fillEqually
        return sv
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = ""
        setupViews()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.clearNavBarAppearance()
    }
    
    fileprivate func setupViews() {
        [titleLabel, mainStackView, customView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customView.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            customView.heightAnchor.constraint(equalToConstant: (view.frame.height - 380)),
        ])
        
        customView.addSubview(illustrationView)
        illustrationView.anchor(top: customView.topAnchor, leading: customView.leadingAnchor, bottom: customView.bottomAnchor, trailing: customView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), size: CGSize(width: 0, height: 0))
  
        titleLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right:  30), size: CGSize(width: 0, height: 30))
        
        mainStackView.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 20, bottom: 80, right:  20), size: CGSize(width: 0, height: 105))

    }
    
    @objc func technicianBtnPressed() {
        let vc = TechnicianLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clientBtnPressed() {
        let vc = ClientLoginVC()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
