//
//  LoginVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/11/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import LBTATools
import Firebase
import CodableFirebase

class LoginVC: UIViewController {
    
    var didFetchUserInfo = false
    
    // UserAuthViewModel
    
    fileprivate var defaults = UserDefaults.standard
    var persistUsersInfo = [UserPersistedInfo]()
    
    let imageBackground = UIImage(named: "balance.jpg")
    let logo = UIImage(named: "guidetech-06.png")
    
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
        //        txtFld.borderStyle = .roundedRect
        let placeholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.isSecureTextEntry = true
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var loginBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemPink
        btn.setTitle("Continue", for: .normal)
        
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
//        btn.titleColor(for: .disabled)
        btn.layer.cornerRadius = 6
        btn.tintColor = .systemGray4
        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var forgotPwBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.backgroundColor = .yellow
        btn.setTitle("Forgot Password?", for: .normal)
        
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        //        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .right
        btn.tintColor = .systemPink
        return btn
    }()
    
    lazy var noAccLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = "Don't have an account?"
        //          lb.font = .boldSystemFont(ofSize: 50)
        lbl.textAlignment = .right
        lbl.textColor = .black
        
        
        //        lb.sizeToFit()
        //          lb.backgroundColor = .gray
        return lbl
    }()
    
    lazy var signupLinkBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.backgroundColor = .red
        btn.setTitle("Sign Up", for: .normal)
        
        btn.titleLabel?.textAlignment = .right
        btn.tintColor = .rgb(red: 101, green: 183, blue: 180)
        
        //        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        //        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(signupLinkPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var emailStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailTxtFld, separatorOne])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var passwordStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [passwordTxtFld, separatorTwo])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var loginStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, loginBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalSpacing
        return sv
    }()
    
    lazy var labelsStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [noAccLbl, signupLinkBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 3
        sv.distribution = .fillProportionally
        sv.alignment = .center
        //        sv.backgroundColor = .blue
        
        return sv
    }()
    
    private var indicator: ProgressIndicator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var pickAccountType = -1

    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        setupKeyboardListener()
//        setupActivityIndicator()
        
//        loginBtn.isEnabled = false
        
        setupView()
//        checkFirstTimeUser()
        handleLoginBtnUX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Singleton delegate
        
        // Remove keyboard's height observer from signUpVC
        NotificationCenter.default.removeObserver(self)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Functions
    fileprivate func setupView(){
        [loginStackView, forgotPwBtn].forEach({view.addSubview($0)})
        navigationItem.title = "Sign In"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//        navigationController?.navigationBar.tintColor = .systemPink
        
        // setting up activity indicator
//        indicator?.anchor(top: loginBtn.topAnchor, leading: view.leadingAnchor, bottom: loginBtn.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: view.frame.width/2 - 20, bottom: 0, right: view.frame.width/2 - 20))
                
        loginStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets.init(top: 10, left: 20, bottom: 0, right: 20))
        
        forgotPwBtn.anchor(top: loginStackView.bottomAnchor, leading: loginStackView.leadingAnchor, bottom: nil, trailing: loginStackView.trailingAnchor, padding: UIEdgeInsets.init(top: 5, left: view.frame.width/8.5, bottom: 0, right: view.frame.width/8.5))
        
        emailStackView.withHeight(45)
//        passwordStackView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize.init(width: view.frame.width - 80, height: 45))
        passwordStackView.withHeight(45)
        separatorOne.withHeight(1)
        separatorTwo.withHeight(1)
        loginBtn.withHeight(45)
//        forgotPwBtn.withWidth(60)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.hideNavBarSeperator()
    }
    
    fileprivate func handleLoginBtnUX(){
        /// Handles accessibility to the SingUp button
        emailTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        
        /// Handles separator color changing
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
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
    
    fileprivate func setupKeyboardListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupActivityIndicator(){
        // Setting up activity indicator
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.white, msg: "")
        indicator?.isHidden = true
    }
    
    fileprivate func checkFirstTimeUser(){
        // MARK: Shows the view when user open it for the first time
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            defaults.synchronize()
        }
        
    }
    
    // MARK: - Selectors
    @objc fileprivate func textFldEditingDidBegin(txtFld: UITextField){
        
        if emailTxtFld.isEditing == true {
            separatorOne.backgroundColor = .systemPink
            
        } else if passwordTxtFld.isEditing == true {
            separatorTwo.backgroundColor = .systemPink
            
        }
    }
    
    @objc fileprivate func textFldEditingDidEnd(txtFld: UITextField){
        separatorOne.backgroundColor = .lightGray
        separatorTwo.backgroundColor = .lightGray
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if view.bounds.height <= 667{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (keyboardSize.height - keyboardSize.height) + 70
                }
            }
        } else {
            print("bigger size screen")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.bounds.height <= 667{
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        } else {
            print("bigger size screen")
        }
    }
    
    @objc func signupLinkPressed(){
        view.endEditing(true)
        let signupVC = SignupVC()
        //        self.present(signupVC, animated: true)
        signupVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc func loginBtnPressed(){
        //        indicator?.isHidden = false
        //        view.endEditing(true)
        //        view.isUserInteractionEnabled = false
        // validate text fields
        
        // creates clean version of textfield
        //        guard let email = emailTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        //              let password = passwordTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        //        else { return }
        
        // SignIn user
        Auth.auth().signIn(withEmail: emailTxtFld.text!, password: passwordTxtFld.text!) { [self] (result, error) in
            if error != nil {
                print("ERROR: " + error!.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            guard let user = result?.user else { return }
            
            if pickAccountType == 0 {
                DatabaseManager.shared.getAllTechnicians(completion: { result in
                    switch result {
                    case .success(let users):
                        if uid == users.profileInfo.id {
                            self.persistData(withEmail: user.email, withName: users.profileInfo.name, withLocation: users.profileInfo.location)
                            
                            let vc = TechnieTabController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                        }
                    case .failure(let error):
                        print("Failed to get all technicians: \(error.localizedDescription)")
                    }
                })
                
                
            } else {
                
                DatabaseManager.shared.getAllClients(completion: { result in
                    switch result {
                    case .success(let users):
                        //                    posts = postsCollection
                        //                    print("success: \(users)")
                        //                    print("budget: \(posts.budget)")
                        
                        if uid == users.profileInfo.id {
                            self.persistData(withEmail: user.email, withName: users.profileInfo.name, withLocation: users.profileInfo.location)
                            
                            let vc = ClientTabController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                        }
                    //                        if keys == "-MU8vTecV1Bid3Lt_WWR" {
                    //                            print("INSIDE KEY: \(keys)")
                    //
                    //                        database.child("posts/\(keys)").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                    //                            let newElement = [
                    //                                "title": "post.title",
                    //                            ] //as [String : Any]
                    //                            let childPath = "posts/\(keys)"
                    //                            database.child(childPath).updateChildValues(newElement, withCompletionBlock: { error, _ in
                    //
                    //                            })
                    //                        })
                    //                    }
                    
                    
                    //                    DatabaseManager.shared.getUserPosts(completion: { result in
                    //                        switch result {
                    //                        case .success(let userPostsCollection):
                    //                            //                        print("success: \(userPostsCollection)")
                    //                            for post in userPostsCollection {
                    //                                for (_ , value) in post {
                    //                                    let userPost = posts["\(value)"] as! [String: Any]
                    //                                    print("THIS: \(userPost), \(value)")
                    //                                    userPosts.append(userPost)
                    //                                }
                    //                            }
                    //                            print("userPosts: \(userPosts)")
                    //                        case .failure(let error):
                    //                            print("Failed to get posts: \(error.localizedDescription)")
                    //                        }
                    //                    })
                    
                    case .failure(let error):
                        print("Failed to get all technicians: \(error.localizedDescription)")
                    }
                })
                
                //            DatabaseManager.shared.insertPost(with: <#PostModel#>, completion: { success in
                //                if success {
                //                    print("success")
                //                } else {
                //                    print("failed")
                //                }
                //            })
                
                //            let vc = ClientTabController()
                //            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }
        }
        
        
    }
    
    private func persistData(withEmail email: String?, withName name: String?, withLocation location: String?) {
        guard let name = name,
              let email = email ,
              let location = location
        else { return }
        
        let newItem = UserPersistedInfo(name: name,
                                        email: email,
                                        location: location,
                                        accountType: nil,
                                        locationInLongLat: nil,
                                        profileImage: nil)
        
        if email != self.persistUsersInfo.first?.email {
            self.persistUsersInfo.append(newItem)
            print("data persisted: \(self.persistUsersInfo)")
        } else {
            print("existing Name")
        }
        
        self.defaults.set(object: self.persistUsersInfo, forKey: "persistUsersInfo")
    }
    

    
    @objc fileprivate func textFldDidChange(){
        guard let email = emailTxtFld.text, !email.isEmpty, let password = passwordTxtFld.text, !password.isEmpty else {
            return
        }
        
    }
}

