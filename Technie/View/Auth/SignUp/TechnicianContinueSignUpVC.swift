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

import MobileCoreServices
import UniformTypeIdentifiers

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
    var proofOfExpertise: Data?
    var isProofOfExpertiseFileSelected = false
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
            guard let proofOfExpertise = proofOfExpertise else { return }
            let filename = "\(email)_\(UUID().uuidString)"
            var urls = [String]()
            StorageManager.shared.uploadProfilePictureAndCertificate(with: imageData, certificateFile: proofOfExpertise, fileName: filename, completion: { result in
                switch result {
                case .success(let profileImageUrl):
                    urls.append(profileImageUrl)
                case .failure(let error):
                    print("Storage manager error: \(error)")
                }
            }, certificateCompletion: { result in
                switch result {
                
                case .success(let certificateUrl):
                    self.createUser(with: urls[0], proofOfExpertise: certificateUrl)
                case .failure(let error):
                    print("Storage manager error: \(error)")
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
    
    func createUser(with profileImage: String, proofOfExpertise: String) {

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
                                                                  proofOfExpertise: proofOfExpertise,
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
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TechnicianContinueCell.cellID, for: indexPath) as! TechnicianContinueCell
        cell = TechnicianContinueCell(style: .value1, reuseIdentifier: TechnicianContinueCell.cellID)
        cell.detailTextLabel?.font = .systemFont(ofSize: 12.5)
        let rowTitle = ["Years of Experience", "Expertise", "Proof of Expertise", "Account Type", "Hourly Rate"]

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
            var detailText = ""
            isProofOfExpertiseFileSelected == false ? (detailText = "Choose") : (detailText = "File Selected")
            cell.detailTextLabel?.text = detailText
            
            cell.accessoryType = .detailDisclosureButton
            cell.selectionStyle = .default
            
        case 4:
            cell.textLabel?.text = rowTitle[3]
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
        case 5:
            cell.textLabel?.text = rowTitle[4]
            var label = ""
            hourlyRate == nil ? (label = "Choose") : (label = "₱\(hourlyRate ?? "")")
            cell.detailTextLabel?.text = label
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
        case 6:
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
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if indexPath.row == 3 {
            presentProofOfExprtiseAlert()
        }
    }
    
    func presentProofOfExprtiseAlert() {
        let alertController = UIAlertController(title: nil, message: "Submit a document that proves your skillset/services.", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
      
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
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
            print("proof of expertise")
            presentPhotoInputActionsheet()
        case 4:
            accountTypeDrowDown.show()
            
        case 5:
            presentEnterHourlyRateAlertController()
        default:
            break
        }
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: "Select .pdf .docx .png .jpeg",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
//            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
//            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "File", style: .default, handler: nil))
        actionSheet.actions[2].isEnabled = false
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.fixActionSheetConstraintsError()
        present(actionSheet, animated: true)
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

// MARK: - UIImagePickerControllerDelegate Extension
extension TechnicianContinueSignUpVC: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
//            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
//            let fileName = fileUrl.lastPathComponent
//            let fileType = fileUrl.pathExtension
//            fileType == "jpeg" ? (selectedImage = image.jpegData(compressionQuality: 0.4)!) : (selectedImage = image.pngData()!)

            // Convert selectedImage into Data type
            if let selectedImage = image.jpegData(compressionQuality: 0.5) {//image.pngData()
                proofOfExpertise = selectedImage
                isProofOfExpertiseFileSelected = true
                self.tableView.reloadData()
                print("proofOfExpertise: ", proofOfExpertise, ", profileImage: ", imageData)
            }
           
        }
    }
    
}

// MARK: - File Picker Handler Extension
extension TechnicianContinueSignUpVC: UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func selectFiles() {
        let types = UTType.types(tag: "json",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(
                forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
          

    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func clickFunction(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}
