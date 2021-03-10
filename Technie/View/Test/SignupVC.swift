//
//  SignupVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/11/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import LBTATools
import Firebase

class SignupVC: UIViewController {
    
    fileprivate var defaults = UserDefaults.standard
    var persistUsersInfo = [UserPersistedInfo]()
    
    // MARK: - UserAuthViewModel
    let imageBackground = UIImage(named: "balance.jpg")
    
    var selectedImage: UIImage?
    
    lazy var profileImageViewPicker: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        iv.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        //        iv.sizeToFit()
        iv.contentMode = .scaleAspectFill
        //        iv.backgroundColor = .red
        return iv
    }()
    
    lazy var separatorOne: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var separatorTwo: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var separatorThree: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var separatorFour: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var separatorFive: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.withHeight(1)
        return view
    }()
    
    lazy var emailTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //        txtFld.backgroundColor = .blue
        let placeholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.placeholder = "Email"
        //        txtFld.borderStyle = .roundedRect
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var passwordTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //        txtFld.backgroundColor = .red
        
        let placeholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.isSecureTextEntry = true
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var firstNameTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //                txtFld.backgroundColor = .red
        
        let placeholder = NSAttributedString(string: "First name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var lastNameTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //                txtFld.backgroundColor = .red
        
        let placeholder = NSAttributedString(string: "Last name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var locationTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //                txtFld.backgroundColor = .red
        
        let placeholder = NSAttributedString(string: "Location", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var signupBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemPink
        
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.titleColor(for: .disabled)
        btn.layer.cornerRadius = 6
        btn.tintColor = .systemGray4
        btn.addTarget(self, action: #selector(signupBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var haveAccLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Already have an account?"
        //          lb.font = .boldSystemFont(ofSize: 50)
        lbl.textAlignment = .right
        lbl.textColor = .black
        //        lb.sizeToFit()
        //              lb.backgroundColor = .gray
        return lbl
    }()
    
    lazy var pickerLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Add a profile photo"
        lbl.textColor = .systemPink
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var emailStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailTxtFld, separatorOne])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var firstNameStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [firstNameTxtFld, separatorTwo])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var lastNameStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [lastNameTxtFld, separatorThree])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var locationStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [locationTxtFld, separatorFive])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var passwordStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [passwordTxtFld, separatorFour])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var signUpStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailStackView, firstNameStackView, lastNameStackView, locationStackView, passwordStackView, signupBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalSpacing
        return sv
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

    var pickAccountType = -1
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        // Setting up activity indicator
//        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.white, msg: "")
//
//        indicator?.isHidden = true
//        signupBtn.isEnabled = false
//
        setupView()
        handleSignupBtnUX()
        
        //            assignbackground()
        //        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "balance.jpg")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Singleton delegate
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Remove keyboard's height observer
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImageViewPicker.roundedImage()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        self.setupToHideKeyboardOnTapOnView()
//        view.endEditing(true)
//
//    }
    
    // MARK: - Functions
    fileprivate func setupView(){
        // Costumizing Navbar
        navigationItem.title = "Create an account"
  
        [pickerStackView, signUpStackView].forEach({view.addSubview($0)})
        
        
        // stackview containers:
        pickerStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: view.frame.width/2 - 75, bottom: 0, right: 0), size: CGSize.init(width: 150, height: 130))
        
        customView.addSubview(profileImageViewPicker)
        NSLayoutConstraint.activate([
            profileImageViewPicker.widthAnchor.constraint(equalToConstant: 100),
            profileImageViewPicker.heightAnchor.constraint(equalToConstant: 100),
            profileImageViewPicker.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            profileImageViewPicker.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
        ])
        
        signUpStackView.anchor(top: pickerStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets.init(top: 10, left: 20, bottom: 0, right: 20))
        
        firstNameStackView.withHeight(45)
        lastNameStackView.withHeight(45)
        emailStackView.withHeight(45)
        passwordStackView.withHeight(45)
        separatorOne.withHeight(1)
        separatorTwo.withHeight(1)
        separatorThree.withHeight(1)
        separatorFour.withHeight(1)
        signupBtn.withHeight(45)
        
        // Handles keyboard dismissal
        self.setupToHideKeyboardOnTapOnView()
        
        // Gets Keyboard's height with an observer
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyBoardDidShow(_:)), name:  UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    fileprivate func assignbackground(){
        let background = UIImage(named: "AbstractDark.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    fileprivate func validateFields() -> String? {
        // check that all fields are filled in
        if firstNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    fileprivate func handleSignupBtnUX(){
        /// Handles accessibility to the SingUp button
        firstNameTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        lastNameTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        emailTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        
        /// Handles separator color changing
        firstNameTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        firstNameTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        lastNameTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        lastNameTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
    }
    
    
    // MARK: - Selectors
    @objc func keyBoardDidShow(_ notification:Notification) {
        
        let keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        let stackViewsHeight = (pickerStackView.frame.height + signUpStackView.frame.height + 25)
        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        let stackViewsFullHeight = stackViewsHeight + keyboardHeight + navBarHeight
        let screenViewHeight = view.frame.size.height
        
        let dynamicLineUpCalcForKeyboard = (screenViewHeight - stackViewsHeight - keyboardHeight) + 10
        
//        UIView.animate(withDuration: 0.3) {
//            stackViewsFullHeight < screenViewHeight ? (self.scrollView.contentOffset.y = 0) : (self.scrollView.contentOffset.y = dynamicLineUpCalcForKeyboard)
//        }

    }
    
    @objc fileprivate func textFldEditingDidBegin(txtFld: UITextField){
        
        if emailTxtFld.isEditing == true {
            separatorOne.backgroundColor = .systemPink
            
        } else if firstNameTxtFld.isEditing == true {
            separatorTwo.backgroundColor = .systemPink
            
        } else if lastNameTxtFld.isEditing == true {
            separatorThree.backgroundColor = .systemPink
            
        } else if passwordTxtFld.isEditing == true {
            separatorFour.backgroundColor = .systemPink
        }
        
    }
    
    @objc fileprivate func textFldEditingDidEnd(txtFld: UITextField){
        separatorOne.backgroundColor = .lightGray
        separatorTwo.backgroundColor = .lightGray
        separatorThree.backgroundColor = .lightGray
        separatorFour.backgroundColor = .lightGray
        
//        UIView.animate(withDuration: 0.3) {
//            /// brings back the Offset to the initial state when in a smaller screen (also for bigger screen if needed)
//            self.scrollView.contentOffset.y = 0
//        }
       
    }
    
    @objc fileprivate func textFldDidChange(txtFld: UITextField){
        //        txtFld.isEditing == false ? (separatorTwo.backgroundColor = .lightGray) : (separatorTwo.backgroundColor = .systemPink)
        
        guard
            let username = firstNameTxtFld.text, !username.isEmpty,
            let email = emailTxtFld.text, !email.isEmpty,
            let password = passwordTxtFld.text, !password.isEmpty
        else {
            
//            self.signupBtn.titleColor(for: .disabled)
//            self.signupBtn.isEnabled = false
            return
        }
        
//        signupBtn.titleColor(for: .normal)
//        signupBtn.setTitleColor(.white, for: .normal)
//        signupBtn.isEnabled = true
    }
    
    @objc func handleSelectedProfileIV() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
}

// MARK: - UIImagePickerControllerDelegate Extension
extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    
    // MARK: Selectors
    @objc func closeViewBtnPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loginLinkPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func signupBtnPressed(){
        
        if selectedImage == nil
        {
            print("No Selected Image")
            
            let alertController = UIAlertController(title: "Missing Profile Photo.", message: "Please choose a profile photo.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
           
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
               
                // presenting alertController
                alertController.view.tintColor = .systemPink
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
                // Convert selectedImage into Data type
                guard let selectedImage = self.selectedImage?.pngData() else { return }
                guard let email = emailTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let password = passwordTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let firstName = firstNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let middleName = lastNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let lastName = lastNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let location = locationTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                else { return }
                Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
                    if error != nil {
                        print("ERROR: " + error!.localizedDescription)
                        return
                    }
                    
                    let randomNumberForPosts = Int.random(in: 0...500)
                    let randomNumberForActivePosts = Int.random(in: 0...500)
                    let randomNumberForInactivePosts = Int.random(in: 0...500)
                    let randomNumberExp = Int.random(in: 0...20)
                    let randomHourlyRate = Int.random(in: 200...800)
                    
//                    let randomNumberForCompletedServices = Int.random(in: 0...500)
//                    let randomNumberForActiveServices = Int.random(in: 0...500)
//                    let randomNumberForPreviousServices = Int.random(in: 0...500)
//                    let randomNumberForTechnieRank = Int.random(in: 0...500)
                    
                    guard let uid = result?.user.uid else { return }

                    let dateString = PostFormVC.dateFormatter.string(from: Date())
//                    let autoUID = "\(email)_\(uid)"
                    let clientProfileInfo = ClientProfileInfo(id: uid,
                                                              email: email,
                                                              location: location,
                                                              name: "\(firstName) "+lastName,
                                                              membershipDate: dateString)
                    
                    let client = ClientModel(numberOfActivePosts: randomNumberForActivePosts,
                                             numberOfInactivePosts: randomNumberForInactivePosts,
                                             numberOfPosts: randomNumberForPosts,
                                             profileInfo: clientProfileInfo,
                                             servicePosts: nil)
                    
                    let technicianProfileInfo = TechnicianProfileInfo(id: uid,
                                                                      name: "\(firstName) "+lastName,
                                                                      email: email,
                                                                      profileImage: nil,
                                                                      location: location,
                                                                      profileSummary: "I am this and that",
                                                                      experience: "\(randomNumberExp)",
                                                                      accountType: "Personal",
                                                                      hourlyRate: randomHourlyRate,
                                                                      skills: ["Plumber", "Handyman"],
                                                                      membershipDate: dateString)
                    
                    let technician = TechnicianModel(numberOfCompletedServices: 0,
                                                     numberOfActiveServices: 0,
                                                     numberOfServices: 0,
                                                     technieRank: 0,
                                                     profileInfo: technicianProfileInfo)
                    if pickAccountType == 0 {
                        DatabaseManager.shared.insertTechnician(with: technician, with: uid, firstName: firstName, lastName: lastName, completion: { success in
                            if success {
                            }
                        })
                        
//                        let vc = TechnieTabController()
//                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                    } else {
                        DatabaseManager.shared.insertClient(with: client, with: uid, firstName: firstName, lastName: lastName, completion: { success in
                            if success {
                                print("success")
                            } else {
                                print("failed")
                            }
                        })
//                        DatabaseManager.shared.insertClientUser(with: clientUser, completion: { success in
//                            if success {
//    //                            let data = selectedImage
//    //                            let filename = user.profilePictureFileName
//    //                            StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
//    //                                switch result {
//    //                                case .success(let downloadUrl):
//    ////                                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//    //                                    print(downloadUrl)
//    //                                case .failure(let error):
//    //                                    print("Storage maanger error: \(error)")
//    //                                }
//    //                            })
//                            }
//                        })
                        
//                        let vc = ClientTabController()
//                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                    }
                }
            }
            
        }
        
    } // end of sign up btn func handler
    
}
