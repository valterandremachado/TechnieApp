//
//  TechnicianContinueSignUpVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit
import DropDown
import FirebaseAuth
import FirebaseDatabase

class TechnicianContinueSignUpVC: UIViewController, UITextViewDelegate {

    var imageData: Data?
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var address: String?
    var lat: Double = 0.0
    var long: Double = 0.0

    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(TechnicianContinueCell.self, forCellReuseIdentifier: TechnicianContinueCell.cellID)
        return tv
    }()
    
    lazy var headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Write about yourself in few words."
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Summary..."
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    lazy var summaryTextField: UITextView = {
        let txtView = UITextView()
        txtView.delegate = self
        txtView.font = .systemFont(ofSize: 15)
        txtView.textAlignment = .natural
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.backgroundColor = UIColor(named: "textViewBackgroundColor")
        txtView.clipsToBounds = true
        txtView.layer.cornerRadius = 10
        txtView.isEditable = true
        txtView.isScrollEnabled = false
        return txtView
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
    
    let accountTypes = ["Personal", "Enterprise"]
    
    lazy var accountTypeDrowDown: DropDown = {
        let dropDown = DropDown(frame: CGRect(x: 0, y: 0, width: 110, height: 0))
        dropDown.dataSource = accountTypes
        dropDown.clipsToBounds = true
        dropDown.layer.cornerRadius = 20

        dropDown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            print(item)
//            self.changeUserAccountType(accountType: item)

            self.accountType = item
//            self.tableView.beginUpdates()
            self.tableView.reloadData()//reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
//            self.tableView.endUpdates()
            dropDown.hide()
        }
        
        return dropDown
    }()
    
    var indicator: ProgressIndicator?

    var yearsOfExp: String?
    var expertise: [String]?
    var accountType: String?
    var hourlyRate: String?
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        indicator = ProgressIndicator(inview: self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.white, msg: "")
        indicator?.isHidden = false
//        signupBtn.isEnabled = false
//        indicator?.start()
        print("dataToSave: ", imageData, address, email, firstName, lastName, password, lat, long)
        setupViews()
        self.hideKeyboardWhenTappedAround()
    }
 

    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0) }
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navbar = navigationController?.navigationBar else { return }
        navigationItem.title = "Profile Info"
//        navbar.prefersLargeTitles = false
        navbar.prefersLargeTitles = true
//        navigationController?.navigationBar.defaultNavBarAppearance()
    }
    
    fileprivate func validateFields() -> String? {
        // check that all fields are filled in
        guard ((summaryTextField.text.isEmpty) != nil), ((yearsOfExp?.isEmpty) != nil), ((expertise?.isEmpty) != nil), ((accountType?.isEmpty) != nil), ((hourlyRate?.isEmpty) != nil) else {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    // MARK: - Selectors

    @objc func signupBtnTapped() {
        
        indicator?.isHidden = false
        view.endEditing(true)
        signupBtn.setTitle("", for: .normal)
        view.isUserInteractionEnabled = false
        indicator!.start()
        
        // validate text fields
        let error = validateFields()
        
        if error != nil {
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
        } else {
            print("error free")
            
            guard let email = email else { return }
            guard let imageData = imageData else { return }
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
    
}

// MARK: - ExpertiseVCDelegate Extension
extension TechnicianContinueSignUpVC: ExpertiseVCDelegate {
    
    func fetchSelectedSkills(skills: [String]) {
        expertise = skills
        self.tableView.reloadData()
    }
    
}

// MARK: - Signup Functionality Handler Extension
extension TechnicianContinueSignUpVC {
    
    private func setUserPersistedData(data: UserPersistedInfo) {
        UserDefaults.standard.set(object: data, forKey: "persistUsersInfo")
        print("setPersistedData: ", data)
    }
    
    func createUser(with profileImage: String) {

        guard let email = email else { return }
        guard let password = password else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
            
            switch error {
            case .none:
                print("no error")
                guard let uid = result?.user.uid else { return }
                guard let firstName = firstName else { return }
                guard let lastName = lastName else { return }
                guard let location = address else { return }
                print("no error 2")

                guard let yearsOfExp = yearsOfExp else { return }
                guard let expertise = expertise else { return }
                guard let accountType = accountType else { return }
                print("no error 3: ", hourlyRate)
                guard let hourlyRate = hourlyRate else { return }
                print("no error 4")
                guard let summary = summaryTextField.text else { return }
                print("no error 5")
                
                let dateString = PostFormVC.dateFormatter.string(from: Date())
                let userLocation = UserLocation(address: location, lat: lat, long: long)
                let technicianProfileInfo = TechnicianProfileInfo(id: uid,
                                                                  name: "\(firstName) "+lastName,
                                                                  email: email,
                                                                  profileImage: profileImage,
                                                                  userType: UserType.technician.rawValue,
                                                                  location: userLocation,
                                                                  profileSummary: summary,
                                                                  experience: yearsOfExp,
                                                                  accountType: accountType,
                                                                  hourlyRate: hourlyRate,
                                                                  skills: expertise,
                                                                  membershipDate: dateString)
                
                let technician = TechnicianModel(numberOfCompletedServices: 0,
                                                 numberOfActiveServices: 0,
                                                 numberOfServices: 0,
                                                 technieRank: 0,
                                                 profileInfo: technicianProfileInfo)
                
                let userPersistedLocation = UserPersistedLocation(address: location, lat: lat, long: long)
                let technicianUserPersistedInfo = UserPersistedInfo(uid: uid,
                                                          name: "\(firstName) " + lastName,
                                                          email: email,
                                                          location: userPersistedLocation,
                                                          accountType: accountType,
                                                          profileImage: profileImage,
                                                          hourlyRate: hourlyRate,
                                                          userType: UserType.technician.rawValue)
                
                DatabaseManager.shared.insertTechnician(with: technician, with: uid, firstName: firstName, lastName: lastName, completion: { success in
                    if success {
                        setUserPersistedData(data: technicianUserPersistedInfo)
                        let mainVC = TechnieTabController()
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

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnicianContinueSignUpVC: TableViewDataSourceAndDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        tableView.beginUpdates()
        tableView.endUpdates()

        if !textView.text.replacingOccurrences(of: " ", with: "").isEmpty {
            placeHolderLabel.fadeOut()
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
            placeHolderLabel.fadeIn()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TechnicianContinueCell.cellID, for: indexPath) as! TechnicianContinueCell
        cell = TechnicianContinueCell(style: .value1, reuseIdentifier: TechnicianContinueCell.cellID)
        cell.detailTextLabel?.font = .systemFont(ofSize: 12.5)
        let rowTitle = ["Years of Experience", "Expertise", "Account Type", "Hourly Rate"]

        switch indexPath.row {
        case 0:
            [headerLabel, summaryTextField, placeHolderLabel].forEach{cell.contentView.addSubview($0)}
            
            headerLabel.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: nil, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 20))
            
            summaryTextField.anchor(top: headerLabel.bottomAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
            
            placeHolderLabel.anchor(top: summaryTextField.topAnchor, leading: cell.contentView.leadingAnchor, bottom: summaryTextField.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        case 1:

            cell.textLabel?.text = rowTitle[0]
            cell.detailTextLabel?.text = yearsOfExp ?? "Choose"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case 2:
            let flatStrings = expertise?.joined(separator: ", ")
            cell.textLabel?.text = rowTitle[1]
            cell.detailTextLabel?.text = flatStrings ?? "Choose"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case 3:
            cell.textLabel?.text = rowTitle[2]
            cell.detailTextLabel?.text = accountType ?? "Choose"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            accountTypes.forEach { item in
                if cell.detailTextLabel?.text == item {
                    let indexOf = accountTypes.firstIndex(of: item)
                    accountTypeDrowDown.selectRow(indexOf!)
                }
            }

            accountTypeDrowDown.anchorView =  cell.detailTextLabel
            accountTypeDrowDown.bottomOffset = CGPoint(x: -40, y: cell.detailTextLabel?.intrinsicContentSize.height ?? 0 + 8)
        case 4:
            cell.textLabel?.text = rowTitle[3]
            cell.detailTextLabel?.text = "₱\(hourlyRate ?? "Choose")" 
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case 5:
            [signupBtn, indicator!].forEach { cell.contentView.addSubview($0) }
            signupBtn.anchor(top: nil, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: cell.separatorInset.left + 5, bottom: 0, right: cell.separatorInset.left + 5), size: CGSize(width: 0, height: 40))
            
//            NSLayoutConstraint.activate([
//                indicator!.widthAnchor.constraint(equalToConstant: 100),
//                indicator!.heightAnchor.constraint(equalToConstant: 100),
//                indicator!.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
//                indicator!.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
//            ])
            // setting up activity indicator
            indicator?.anchor(top: signupBtn.topAnchor, leading: cell.leadingAnchor, bottom: signupBtn.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: cell.frame.width/2 + 10, bottom: 0, right: cell.frame.width/2 + 10))

        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            presentExperienceAlertController()
        case 2:
            let vc = ExpertiseVC()
            vc.isComingFromSignupVC = true
            vc.expertiseVCDelegate = self
            present(UINavigationController(rootViewController: vc), animated: true)
        case 3:
            accountTypeDrowDown.show()
        case 4:
            presentEnterHourlyRateAlertController()
        default:
            break
        }
    }
    
    fileprivate func presentEnterHourlyRateAlertController() {
        var rateField = UITextField()
        rateField.placeholder = "ex: ₱300"
        
        let alertController = UIAlertController(title: "Hourly Rate", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let rateInput = alertController.textFields?[0] else { return }

                guard let rate = Int(rateInput.text!) else { return }
                hourlyRate = "\(rate)"
                
//                self.tableView.beginUpdates()
                self.tableView.reloadData()//reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
//                self.tableView.endUpdates()
         
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.keyboardType = .numberPad
            addTextField.placeholder = "ex: ₱300"
            rateField = addTextField
        }
        
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func presentExperienceAlertController() {
        var rateField = UITextField()
        rateField.placeholder = "Experience (ex: 0.5, 1)"
        
        let alertController = UIAlertController(title: "Experience", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let rateInput = alertController.textFields?[0] else { return }

                guard let rate = Int(rateInput.text!) else { return }
                yearsOfExp = "\(rate)"
                
//                self.tableView.beginUpdates()
                self.tableView.reloadData()//reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
//                self.tableView.endUpdates()
         
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.keyboardType = .numberPad
            addTextField.placeholder = "Experience (ex: 0.5, 1)"
            rateField = addTextField
        }
        
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
}
