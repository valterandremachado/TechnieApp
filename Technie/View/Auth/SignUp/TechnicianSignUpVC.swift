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
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
        tf.borderActiveColor = .systemPink
        tf.borderInactiveColor = .gray
        return tf
    }()
    
    lazy var firstNameTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "First name"
        tf.placeholderFontScale = 0.85
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
        tf.borderActiveColor = .systemPink
        tf.borderInactiveColor = .gray
        return tf
    }()
    
    lazy var lastNameTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Last name"
        tf.placeholderFontScale = 0.85
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
        tf.borderActiveColor = .systemPink
        tf.borderInactiveColor = .gray
        return tf
    }()
    
    lazy var passwordTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.placeholder = "Password"
        tf.placeholderFontScale = 0.85
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
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
        
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
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
        
    var selectedImage: UIImage?
    var selectedImagData: Data?
    var lat: Double = 0.0
    var long: Double = 0.0
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        continueBtn.isEnabled = false
        
        setupViews()
        handleSignupBtnUX()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImageViewPicker.roundedImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        handleSignupBtnUX()
//
//        listenToTextFieldsChanges()
//        indicator?.isHidden = true
//        continueBtn.isEnabled = false
//        view.isUserInteractionEnabled = true
//        continueBtn.setTitle("Continue", for: .normal)
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
        navbar.prefersLargeTitles = true
    }
    
    private func continueTotheNextScreen() {
//        indicator?.isHidden = false
//        view.endEditing(true)
//        view.isUserInteractionEnabled = false
//        // validate text fields
//        continueBtn.setTitle("", for: .normal)
//        indicator!.start()
        
        if selectedImage == nil
        {
            print("No Selected Image")
            
            let alertController = UIAlertController(title: "Missing Profile Photo.", message: "Please choose a profile photo.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.continueBtn.setTitle("Continue", for: .normal)
            self.view.isUserInteractionEnabled = true
            self.continueBtn.isEnabled = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            print("An image was selected")
            
            let error = validateFields()
            
            if error != nil {
                // can also check password validation
                print("Please fill in all fields.")
                
                let alertController = UIAlertController(title: "Please fill in all fields.", message: "", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
                // enable UX
                self.continueBtn.setTitle("Continue", for: .normal)
                self.view.isUserInteractionEnabled = true
                self.continueBtn.isEnabled = true
                // presenting alertController
                alertController.view.tintColor = .systemPink
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
                // Convert selectedImage into Data type
                guard let selectedImage = self.selectedImage?.jpegData(compressionQuality: 0.4) else { return }
                selectedImagData = selectedImage
                
            }
            
        }
        
    }
    
    // MARK: - Selectors
    @objc fileprivate func continueBtnPressed() {
        continueTotheNextScreen()
        
        if selectedImagData != nil {
            let vc = TechnicianContinueSignUpVC()
            vc.imageData = selectedImagData
            vc.email = emailTextField.text
            vc.password = passwordTextField.text
            vc.firstName = firstNameTextField.text
            vc.lastName = lastNameTextField.text
            vc.address = locationTextField.text
            vc.lat = lat
            vc.long = long
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func handleSelectedProfileIV() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func locationTextFieldTapped() {
        let vc = SelectLocationVC()
        vc.selectedLocationDelegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc fileprivate func textFldDidChange(textField: UITextField){
        listenToTextFieldsChanges()
    }
    
}
// MARK: - UX Handler Extension
extension TechnicianSignUpVC {
    
    fileprivate func listenToTextFieldsChanges() {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let location = locationTextField.text, !location.isEmpty
        else {
            
            self.continueBtn.titleColor(for: .disabled)
            self.continueBtn.isEnabled = false
            return
        }
        
        continueBtn.titleColor(for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.isEnabled = true
    }
    
    fileprivate func handleSignupBtnUX(){
        /// Handles accessibility to the SingUp button
        emailTextField.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        locationTextField.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        
    }
    
    fileprivate func validateFields() -> String? {
        // check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
}

// MARK: - SelectedLocationDelegate Extension
extension TechnicianSignUpVC: SelectedLocationDelegate{
    
    func fetchSelectedAddress(address: String, lat: Double, long: Double) {
        guard !address.isEmpty else { return }
        locationTextField.text = address
        self.lat = lat
        self.long = long
        listenToTextFieldsChanges()
        print("address: ", address, ", lat: \(lat) long: \(long)")
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
        
        textFieldsStackView.anchor(top: pickerStackView.bottomAnchor, leading: cell.leadingAnchor, bottom: nil, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 280))
        
        continueBtn.anchor(top: textFieldsStackView.bottomAnchor, leading: textFieldsStackView.leadingAnchor, bottom: nil, trailing: textFieldsStackView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 40))
        
        return cell
    }
    
    
}
