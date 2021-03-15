//
//  ClientSignUpVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase

class ClientSignUpVC: UIViewController {

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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(locationTextFieldTapped))
        tf.isUserInteractionEnabled = true
        tf.addGestureRecognizer(tapRecognizer)
        return tf
    }()
    
    lazy var signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.setTitle("Create my account", for: .normal)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .systemPink
        btn.addTarget(self, action: #selector(signupBtnTapped), for: .touchUpInside)
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
    
    var indicator: ProgressIndicator?
    
    var selectedImage: UIImage?
    var selectedImagData: Data?
    var lat: Double = 0.0
    var long: Double = 0.0
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.white, msg: "")
        
        indicator?.isHidden = true
        signupBtn.isEnabled = false
        
        setupViews()
        handleSignupBtnUX()
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
        navbar.prefersLargeTitles = true
    }
    
    // MARK: - Selectors
    @objc fileprivate func signupBtnTapped() {
        checkForMissingFields()
        if let imageData = selectedImagData {
            guard let email = emailTextField.text else { return }
            let filename = "\(email)_\(UUID().uuidString)"

            StorageManager.shared.uploadProfilePicture(with: imageData, fileName: filename, completion: { result in
                switch result {
                case .success(let downloadUrl):
                    self.createUser(with: downloadUrl)

                case .failure(let error):
                    print("Storage maanger error: \(error)")
                }
            })
        }
    }
    
    @objc fileprivate func textFldDidChange(textField: UITextField){
        listenToTextFieldsChanges()
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
}

// MARK: - UX Handler Extension
extension ClientSignUpVC {
    
    fileprivate func listenToTextFieldsChanges() {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let location = locationTextField.text, !location.isEmpty
        else {
            
            self.signupBtn.titleColor(for: .disabled)
            self.signupBtn.isEnabled = false
            return
        }
        
        signupBtn.titleColor(for: .normal)
        signupBtn.setTitleColor(.white, for: .normal)
        signupBtn.isEnabled = true
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
    
    private func checkForMissingFields() {
        indicator?.isHidden = false
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        // validate text fields
        signupBtn.setTitle("", for: .normal)
        indicator!.start()
        
        if selectedImage == nil
        {
            print("No Selected Image")
            
            let alertController = UIAlertController(title: "Missing Profile Photo.", message: "Please choose a profile photo.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.signupBtn.setTitle("Create my account", for: .normal)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
            self.indicator?.isHidden = true
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
                self.indicator!.stop()
                self.signupBtn.setTitle("Create my account", for: .normal)
                self.view.isUserInteractionEnabled = true
                self.signupBtn.isEnabled = true
                self.indicator?.isHidden = true
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
                
                // Create user
                
                // Store user in the Database
                
            }
            
        }
        
    } // end of sign up btn func handler
    
}

// MARK: - Signup Functionality Handler Extension
extension ClientSignUpVC {
    
    private func setUserPersistedData(data: UserPersistedInfo) {
        UserDefaults.standard.set(object: data, forKey: "persistUsersInfo")
        print("setPersistedData: ", data)
    }
    
    func createUser(with profileImage: String) {

        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
            
            switch error {
            case .none:
                print("no error")
                guard let uid = result?.user.uid else { return }
                guard let firstName = firstNameTextField.text else { return }
                guard let lastName = lastNameTextField.text else { return }
                guard let location = locationTextField.text else { return }
                guard !location.isEmpty else { return }
                
                let dateString = PostFormVC.dateFormatter.string(from: Date())
                let userLocation = UserLocation(address: location, lat: lat, long: long)
                let clientProfileInfo = ClientProfileInfo(id: uid,
                                                          email: email,
                                                          profileImage: profileImage,
                                                          userType: UserType.client.rawValue,
                                                          location: userLocation,
                                                          name: "\(firstName) " + lastName,
                                                          membershipDate: dateString)
                
                let client = ClientModel(numberOfActivePosts: 0,
                                         numberOfInactivePosts: 0,
                                         numberOfPosts: 0,
                                         profileInfo: clientProfileInfo,
                                         servicePosts: nil)
                
                let userPersistedLocation = UserPersistedLocation(address: location, lat: lat, long: long)
                let clientUserPersistedInfo = UserPersistedInfo(uid: uid,
                                                          name: "\(firstName) " + lastName,
                                                          email: email,
                                                          location: userPersistedLocation,
                                                          accountType: nil,
                                                          profileImage: profileImage,
                                                          hourlyRate: nil,
                                                          userType: UserType.client.rawValue)
                
                DatabaseManager.shared.insertClient(with: client, with: uid, firstName: firstName, lastName: lastName, completion: { success in
                    if success {
                        setUserPersistedData(data: clientUserPersistedInfo)
                        let mainVC = ClientTabController()
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC)
                        indicator?.stop()
                        print("success, user inserted")
                    } else {
                        print("failed to insert user")
                    }
                })
                
            case .some(let error):
                
                print("Couldn't Signup the user. because of " + error.localizedDescription)
                userRegistrationCallBack(errorMessage: error.localizedDescription)
            }
        }
    }
    
    fileprivate func userRegistrationCallBack(errorMessage: String) {
        print("userRegistrationCallBack: "+errorMessage)
        var errorReader = errorMessage
        
        if errorReader == "There is no user record corresponding to this identifier. The user may have been deleted."
        {   // handles Email input error
            errorReader = "Incorrect Email"
            
            let alertController = UIAlertController(title: errorReader, message: "The email you entered doesn't appear to belong to an account. Please check your email and try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.signupBtn.setTitle("Create my account", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if errorReader == "The password is invalid or the user does not have a password." {
            // handles password input error
            errorReader = "Incorrect Password"
            
            let alertController = UIAlertController(title: errorReader, message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.signupBtn.setTitle("Create my account", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        }  else if errorReader == "Network error (such as timeout, interrupted connection or unreachable host) has occurred." {
            // handles time out error
            errorReader = "Connection Issue"
            
            let alertController = UIAlertController(title: errorReader, message: "We are having problem to connect with our server. Please try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.signupBtn.setTitle("Create my account", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if errorReader == "Too many unsuccessful login attempts. Please try again later." {
            // handles Too many unsuccessful login attempts error
            errorReader = "Forgot Password?"
            
            let alertController = UIAlertController(title: errorReader, message: "You entered many times a wrong password. Do you want to reset your password?.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { UIAlertAction in
                let forgotPwVC = ForgotPasswordVC()
                self.present(forgotPwVC, animated: true, completion: nil)
            }
            
            let tryAgainAction = UIAlertAction(title: "No", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.signupBtn.setTitle("Create my account", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(yesAction)
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        let alertController = UIAlertController(title: errorReader, message: "", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
        // enable UX
        self.indicator!.stop()
        self.signupBtn.setTitle("Create my account", for: .normal)
        print("Couldn't Sign Up: " + errorReader)
        self.view.isUserInteractionEnabled = true
        self.signupBtn.isEnabled = true
        self.indicator?.isHidden = true
        // presenting alertController
        alertController.view.tintColor = .systemPink
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - SelectedLocationDelegate Extension
extension ClientSignUpVC: SelectedLocationDelegate {
    
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
extension ClientSignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension ClientSignUpVC: CollectionDataSourceAndDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthCell.cellID, for: indexPath) as! AuthCell
        
        [pickerStackView, textFieldsStackView, signupBtn, indicator!].forEach { cell.addSubview($0) }
        
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
        
        signupBtn.anchor(top: textFieldsStackView.bottomAnchor, leading: textFieldsStackView.leadingAnchor, bottom: nil, trailing: textFieldsStackView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 40))
        
        // setting up activity indicator
        indicator?.anchor(top: signupBtn.topAnchor, leading: cell.leadingAnchor, bottom: signupBtn.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: cell.frame.width/2 - 20, bottom: 0, right: cell.frame.width/2 - 20))
        
        return cell
    }
    
    
}

// MARK: - ClientSignUpVCPreviews
import SwiftUI

struct ClientSignUpVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = ClientSignUpVC()
        return vc.liveViewController
    }
    
}
