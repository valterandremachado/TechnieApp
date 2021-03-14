//
//  ClientLoginVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit
import TextFieldEffects

class ClientLoginVC: UIViewController {

    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        
        let viewSize = view.frame.size
        let collectionViewSize = CGSize(width: viewSize.width, height: viewSize.height)
        collectionLayout.itemSize = collectionViewSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Avoid collectionView to self adjust its size
//        cv.contentInsetAdjustmentBehavior = .never
        cv.showsVerticalScrollIndicator = false

        cv.delegate = self
        cv.dataSource = self
        cv.register(AuthCell.self, forCellWithReuseIdentifier: AuthCell.cellID)
        return cv
    }()
    
    lazy var emailTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.placeholderFontScale = 0.85
    
        tf.borderActiveColor = .systemPink
        tf.borderInactiveColor = .gray
        return tf
    }()
    
    lazy var passwordTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.placeholderFontScale = 0.85

        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none

        tf.borderActiveColor = .systemPink
        tf.borderInactiveColor = .gray
        return tf
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.setTitle("Log in", for: .normal)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .systemPink
        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)

        return btn
    }()
    
    lazy var forgotPasswordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.setTitle("Forgot Password?", for: .normal)
        btn.tintColor = .systemPink
//        btn.clipsToBounds = true
//        btn.layer.cornerRadius = 5
//        btn.backgroundColor = .systemPink
        return btn
    }()
    
    lazy var btnsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [loginBtn, forgotPasswordBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    lazy var textFieldsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [collectionView].forEach { view.addSubview($0) }
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navbar = navigationController?.navigationBar else { return }
        navigationItem.title = "Log in"
        navbar.prefersLargeTitles = false
    }
    
    // MARK: - Selectors
    @objc func loginBtnPressed() {
        print("123")
    }

}

// MARK: - CollectionDataSourceAndDelegate Extension
extension ClientLoginVC: CollectionDataSourceAndDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthCell.cellID, for: indexPath) as! AuthCell
        
        [textFieldsStackView, btnsStackView].forEach { cell.addSubview($0) }
        
        
        textFieldsStackView.anchor(top: cell.safeAreaLayoutGuide.topAnchor, leading: cell.leadingAnchor, bottom: nil, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 100))
        
        btnsStackView.anchor(top: textFieldsStackView.bottomAnchor, leading: textFieldsStackView.leadingAnchor, bottom: nil, trailing: textFieldsStackView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        loginBtn.withHeight(40)
        
        return cell
    }
    
    
}
