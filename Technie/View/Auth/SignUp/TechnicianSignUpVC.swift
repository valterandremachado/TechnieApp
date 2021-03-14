//
//  TechnicianSignUpVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit
import TextFieldEffects

class TechnicianSignUpVC: UIViewController {
    
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
    
    var selectedImage: UIImage?
    
    lazy var profileImageViewPicker: UIImageView = {
        var iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.roundedImage()
        return iv
    }()
    
    lazy var pickerLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Add a profile photo"
        lbl.textColor = .systemPink
        lbl.textAlignment = .center
        return lbl
    }()
    
    var customView = UIView()
    
    lazy var pickerStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [customView, pickerLbl])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        //        sv.addBackground(color: .brown)
        sv.distribution = .fill
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSelectedProfileIV))
        sv.isUserInteractionEnabled = true
        sv.addGestureRecognizer(tapRecognizer)
        return sv
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
    
    lazy var firstNameTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "First name"
        tf.placeholderFontScale = 0.85
        
        tf.borderActiveColor = .systemPink
        tf.borderInactiveColor = .gray
        return tf
    }()
    
    lazy var lastNameTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Last name"
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
    
    lazy var locationTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "City"
        tf.placeholderFontScale = 0.85
        
        tf.borderActiveColor = .systemPink
        tf.borderInactiveColor = .gray
//        tf.addTarget(self, action: #selector(locationTextFieldTapped), for: .touchUpInside)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(locationTextFieldTapped))
        tf.isUserInteractionEnabled = true
        tf.addGestureRecognizer(tapRecognizer)
        return tf
    }()
    
    lazy var continueBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.setTitle("Continue", for: .normal)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .systemPink
        btn.addTarget(self, action: #selector(continueBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var textFieldsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField, firstNameTextField, lastNameTextField, passwordTextField, locationTextField])
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImageViewPicker.roundedImage()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [collectionView].forEach { view.addSubview($0) }
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navbar = navigationController?.navigationBar else { return }
        navigationItem.title = "Create an account"
        navbar.prefersLargeTitles = false
    }
    
    
    // MARK: - Selectors
    @objc func handleSelectedProfileIV() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func continueBtnPressed() {
        let vc = TechnicianContinueSignUpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func locationTextFieldTapped() {
        let vc = SelectLocationVC()
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    
    
}

// MARK: - CollectionDataSourceAndDelegate Extension
extension TechnicianSignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            profileImageViewPicker.image = image
            pickerLbl.text = "Great!!!"
            pickerLbl.font = .boldSystemFont(ofSize: 18)
        }
        
        print("did pick")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CollectionDataSourceAndDelegate Extension
extension TechnicianSignUpVC: CollectionDataSourceAndDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthCell.cellID, for: indexPath) as! AuthCell
        
        [pickerStackView, textFieldsStackView, continueBtn].forEach { cell.addSubview($0) }
        
        // stackview containers:
        pickerStackView.anchor(top: cell.safeAreaLayoutGuide.topAnchor, leading: cell.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: view.frame.width/2 - 75, bottom: 0, right: 0), size: CGSize.init(width: 150, height: 130))
        
        customView.addSubview(profileImageViewPicker)
        NSLayoutConstraint.activate([
            profileImageViewPicker.widthAnchor.constraint(equalToConstant: 100),
            profileImageViewPicker.heightAnchor.constraint(equalToConstant: 100),
            profileImageViewPicker.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            profileImageViewPicker.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
        ])
        
        textFieldsStackView.anchor(top: pickerStackView.bottomAnchor, leading: cell.leadingAnchor, bottom: nil, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 260))
        
        continueBtn.anchor(top: textFieldsStackView.bottomAnchor, leading: textFieldsStackView.leadingAnchor, bottom: nil, trailing: textFieldsStackView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 40))
        
        return cell
    }
    
    
}
