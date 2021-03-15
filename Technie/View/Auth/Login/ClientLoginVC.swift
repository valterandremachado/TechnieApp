//
//  ClientLoginVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit
import TextFieldEffects
import FirebaseAuth

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
        btn.contentHorizontalAlignment = .right
//        btn.clipsToBounds = true
//        btn.layer.cornerRadius = 5
//        btn.backgroundColor = .systemPink
      
        btn.addTarget(self, action: #selector(forgotPasswordBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [forgotPasswordBtn, loginBtn])
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
    
    lazy var noAccLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Don't have an account?"
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var signupLinkBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Sign Up", for: .normal)
        
        btn.tintColor = .systemPink
        btn.addTarget(self, action: #selector(signupLinkPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var labelsStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [noAccLbl, signupLinkBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fill
        sv.alignment = .center
        return sv
    }()
    
    var indicator: ProgressIndicator?
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.white, msg: "")
        indicator?.isHidden = true
        loginBtn.isEnabled = false

        setupViews()
        handleLoginBtnUX()
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
       
        navigationItem.title = "Login"
        navbar.prefersLargeTitles = true
        navigationController?.navigationBar.defaultNavBarAppearance()
    }
    
    fileprivate func handleLoginBtnUX(){
        /// Handles accessibility to the SingUp button
        emailTextField.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
    }
    
    fileprivate func loginUser(withEmail email: String, withPassword password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [self] (result, error) in
            
            switch error {
            case .none:
                guard let uid = result?.user.uid else { return }
                let mainVC = ClientTabController()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC)
                fetchUserInfoFromDB(withUID: uid)
                indicator?.stop()
                self.indicator!.stop()
                self.loginBtn.setTitle("Log in", for: .normal)
                self.view.isUserInteractionEnabled = true
                self.indicator?.isHidden = false
            case .some(let error):
                print("Couldn't login the user. because of " + error.localizedDescription)
                userAuthCallBack(errorMessage: error.localizedDescription)
            }
            
        }
    }
    
    fileprivate func fetchUserInfoFromDB(withUID clientKeyPath: String) {
        DatabaseManager.shared.getSpecificClient(clientKeyPath: clientKeyPath) { result in
            switch result {
            case .success(let userInfo):
                guard let location = userInfo.profileInfo.location else { return }
                let uid = userInfo.profileInfo.id
                let name = userInfo.profileInfo.name
                let email = userInfo.profileInfo.email
                let userType = userInfo.profileInfo.userType
                guard let profileImage = userInfo.profileInfo.profileImage else { return }

                let userPersistedLocation = UserPersistedLocation(address: location.address, lat: location.lat, long: location.long)
                let clientUserPersistedInfo = UserPersistedInfo(uid: uid,
                                                                name: name,
                                                                email: email,
                                                                location: userPersistedLocation,
                                                                accountType: nil,
                                                                profileImage: profileImage,
                                                                hourlyRate: nil,
                                                                userType: userType)
                
                self.setUserPersistedData(data: clientUserPersistedInfo)
            case .failure(let error):
                print("failed to get user info. ", error.localizedDescription)
            }
        }
        
    }
    
    private func setUserPersistedData(data: UserPersistedInfo) {
        UserDefaults.standard.set(object: data, forKey: "persistUsersInfo")
        print("setPersistedData: ", data)
    }
    
    // MARK: - Selectors
    @objc func loginBtnPressed() {
        indicator?.isHidden = false
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        // validate text fields
        loginBtn.setTitle("", for: .normal)
        indicator!.start()
        
        // creates clean version of textfield
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }

        loginUser(withEmail: email, withPassword: password)
    }
    
    @objc fileprivate func textFldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            loginBtn.titleColor(for: .disabled)
            self.loginBtn.isEnabled = false
            return
        }
        
        loginBtn.titleColor(for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.isEnabled = true
    }

    @objc fileprivate func forgotPasswordBtnPressed() {
        let vc = ForgotPasswordVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func signupLinkPressed() {
        let vc = ClientSignUpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Callback handler Extension
extension ClientLoginVC {
    
    // Error Handler
    func userAuthCallBack(errorMessage: String) {
        var errorReader = errorMessage
        if errorReader == "There is no user record corresponding to this identifier. The user may have been deleted."
        {   // handles Email input error
            errorReader = "Incorrect Email"
            
            let alertController = UIAlertController(title: errorReader, message: "The email you entered doesn't appear to belong to an account. Please check your email and try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.loginBtn.setTitle("Log in", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
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
            self.loginBtn.setTitle("Log in", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
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
            self.loginBtn.setTitle("Log in", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
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
            self.loginBtn.setTitle("Log in", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
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
        self.loginBtn.setTitle("Log in", for: .normal)
        print("Couldn't sign in: " + errorReader)
        self.view.isUserInteractionEnabled = true
        self.loginBtn.isEnabled = true
        self.indicator?.isHidden = true
        // presenting alertController
        alertController.view.tintColor = .systemPink
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - CollectionDataSourceAndDelegate Extension
extension ClientLoginVC: CollectionDataSourceAndDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthCell.cellID, for: indexPath) as! AuthCell
        
        [textFieldsStackView, btnsStackView, indicator!, labelsStackView].forEach { cell.addSubview($0) }
        
        
        textFieldsStackView.anchor(top: cell.safeAreaLayoutGuide.topAnchor, leading: cell.leadingAnchor, bottom: nil, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 100))
        
        btnsStackView.anchor(top: textFieldsStackView.bottomAnchor, leading: textFieldsStackView.leadingAnchor, bottom: nil, trailing: textFieldsStackView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            labelsStackView.widthAnchor.constraint(equalToConstant: 240),
            labelsStackView.heightAnchor.constraint(equalToConstant: 30),
            labelsStackView.centerXAnchor.constraint(equalTo: textFieldsStackView.centerXAnchor),
            labelsStackView.topAnchor.constraint(equalTo: btnsStackView.bottomAnchor, constant: 40)
        ])
                
        loginBtn.withHeight(40)
        
        // setting up activity indicator
        indicator?.anchor(top: loginBtn.topAnchor, leading: cell.leadingAnchor, bottom: loginBtn.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: cell.frame.width/2 - 20, bottom: 0, right: 0))
        
        return cell
    }
    
    
}
