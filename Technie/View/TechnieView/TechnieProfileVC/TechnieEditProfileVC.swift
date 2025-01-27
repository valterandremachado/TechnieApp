//
//  TechnieEditProfile.swift
//  Technie
//
//  Created by Valter A. Machado on 2/18/21.
//

import UIKit
import FirebaseDatabase

protocol TechnieEditProfileVCDismissalDelegate: class {
    func TechnieEditProfileVCDismissalSingleton(updatedPersistedData: UserPersistedInfo)
}

class TechnieEditProfileVC: UIViewController, SelectedLocationDelegate {

    // MARK: - Properties
    let database = Database.database().reference()
    fileprivate var defaults = UserDefaults.standard
    var updatePersistedData: UserPersistedInfo?

    weak var dismissalDelegate: TechnieEditProfileVCDismissalDelegate?
    
    var newProfileImage = Data()
    var newUserName = ""
    var newLocation = ""
    
    var getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.dataSource = self
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .automatic
        
        tv.register(TechnieEditProfileCell.self, forCellReuseIdentifier: TechnieEditProfileCell.cellID)
        return tv
    }()
    
    var isProofOfExpertiseFileSelected = false
    var isProofOfExpertiseTapped = false
    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
//        defaults.removeObject(forKey: "persistUsersInfo")
        print("defaults: \(getUsersPersistedInfo)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let newData = updatePersistedData else { return }
        dismissalDelegate?.TechnieEditProfileVCDismissalSingleton(updatedPersistedData: newData)
//        NotificationCenter.default.post(Notification(name: Notification.Name("updatePersistedData"), object: updatePersistedData, userInfo: nil))
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Edit Profile"
    }
    
    // MARK: - Selectors

}

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnieEditProfileVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TechnieEditProfileCell.cellID, for: indexPath) as! TechnieEditProfileCell
//        let persistedProfileImage = getUsersPersistedInfo?.first?.profileImage
        let persistedUserName = getUsersPersistedInfo?.name ?? "username"
        let persistedLocation = getUsersPersistedInfo?.location.address ?? "userlocation"
        let userPersistedProfileImage = getUsersPersistedInfo?.profileImage ?? ""
        let profileImageUrl = URL(string: userPersistedProfileImage)
        
        switch indexPath.row {
        case 0:
//            var userProfileImage = UIImage(named: "technieDummyPhoto")
            let uploadedUserProfileImage = UIImage(data: newProfileImage)
//            uploadedUserProfileImage == nil ? (userProfileImage = userProfileImage) : (userProfileImage = uploadedUserProfileImage)

            cell.setupViewsOne()
            cell.titleLabel.text = "Profile Photo"
            cell.profileImageView.backgroundColor = .systemGray6

            if uploadedUserProfileImage == nil {
                cell.profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
            } else {
                cell.profileImageView.image = uploadedUserProfileImage
            }
            
        case 1:
            var userDisplayName = ""
            newUserName == "" ? (userDisplayName = persistedUserName) : (userDisplayName = newUserName)
            cell.titleLabel.text = "Display Name"
            cell.descriptionLabel.text = userDisplayName
            
        case 2:
            var userLocation = ""
            newLocation == "" ? (userLocation = persistedLocation) : (userLocation = newLocation)
            cell.titleLabel.text = "Location"
            cell.descriptionLabel.text = userLocation

        case 3:
            cell.titleLabel.text = "Summary"

        case 4:
            cell.titleLabel.text = "Expertise"

        case 5:
            cell.titleLabel.text = "Proof of Expertise"
            var detailText = ""
            isProofOfExpertiseFileSelected == false ? (detailText = "") : (detailText = "File Selected")
            cell.descriptionLabel.text = detailText
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            presentChangePhotoAlertController()
        case 1:
            presentChangeDisplayNameAlertController()
        case 2:
            let vc = SelectLocationVC()
            vc.selectedLocationDelegate = self
            present(UINavigationController(rootViewController: vc), animated: true)
            
        case 3:
            let vc = SummaryVC()
            present(UINavigationController(rootViewController: vc), animated: true)
            
        case 4:
            let vc = ExpertiseVC()
            present(UINavigationController(rootViewController: vc), animated: true)

        case 5:
            presentPhotoInputActionsheet()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove bottom extra 20px space.
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return .leastNormalMagnitude
    }
    
    // AlertControllers
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
            self?.isProofOfExpertiseTapped = true
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
//            picker.allowsEditing = true
            self?.present(picker, animated: true)
            self?.isProofOfExpertiseTapped = true
        }))
        
        actionSheet.addAction(UIAlertAction(title: "File", style: .default, handler: nil))
        actionSheet.actions[2].isEnabled = false
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.fixActionSheetConstraintsError()
        present(actionSheet, animated: true)
    }
    
    fileprivate func presentChangePhotoAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
            print("camera")
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        alertController.fixActionSheetConstraintsError()
        present(alertController, animated: true)
    }
    
    fileprivate func presentChangeDisplayNameAlertController() {
        var firstNameField = UITextField()
        firstNameField.placeholder = "First Name"
        var lastNameField = UITextField()
        lastNameField.placeholder = "Last Name"

        let alertController = UIAlertController(title: "Change Name", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let firstNameField = alertController.textFields?[0] else { return }
            guard let lastNameField = alertController.textFields?[1] else { return }
            newUserName = "\(firstNameField.text!) " + lastNameField.text!
            changeUserName(name: newUserName)
            
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.placeholder = "First Name"
            firstNameField = addTextField
        }
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.placeholder = "Last Name"
            lastNameField = addTextField
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // Database updates
    private func changeUserName(name: String) {
        let updatedPersistedData = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")

        guard let technicianKeyPath = updatedPersistedData?.uid else { return }
        let childPath = "users/technicians/\(technicianKeyPath)/profileInfo"

        guard let uid = updatedPersistedData?.uid,
              let email = updatedPersistedData?.email,
              let location = updatedPersistedData?.location,
              let accountType = updatedPersistedData?.accountType,
              let profileImage = updatedPersistedData?.profileImage,
              let userType = updatedPersistedData?.userType,
              let hourlyRate = updatedPersistedData?.hourlyRate
        else { return }
        
        let newData = UserPersistedInfo(uid: uid,
                                  name: name,
                                  email: email,
                                  location: location,
                                  accountType: accountType,
                                  profileImage: profileImage,
                                  hourlyRate: hourlyRate,
                                  userType: userType)
        
        let updateElement = [
            "name": name
        ]
        
        database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("error changing database")
                return
            }
            self.updatePersistedData(data: newData)
        })
    }
    
    private func changeUserLocation(location: UserPersistedLocation) {
        let updatedPersistedData = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")

        guard let technicianKeyPath = updatedPersistedData?.uid else { return }
        let childPath = "users/technicians/\(technicianKeyPath)/profileInfo"

        guard let uid = updatedPersistedData?.uid,
              let name = updatedPersistedData?.name,
              let email = updatedPersistedData?.email,
              let accountType = updatedPersistedData?.accountType,
              let profileImage = updatedPersistedData?.profileImage,
              let userType = updatedPersistedData?.userType,
              let hourlyRate = updatedPersistedData?.hourlyRate
        else { return }
        
        let newData = UserPersistedInfo(uid: uid,
                                  name: name,
                                  email: email,
                                  location: location,
                                  accountType: accountType,
                                  profileImage: profileImage,
                                  hourlyRate: hourlyRate,
                                  userType: userType)
        
        let updateElement = [
            "location": [
                "address": location.address,
                "lat": location.lat,
                "long": location.long
            ]
        ]
        
        database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("error changing database")
                return
            }
            self.updatePersistedData(data: newData)
        })
    }
    
    private func changeUserProfileImage(image: Data) {
        let updatedPersistedData = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
        
        guard let technicianKeyPath = updatedPersistedData?.uid else { return }
        let childPath = "users/technicians/\(technicianKeyPath)/profileInfo"
        
        guard let uid = updatedPersistedData?.uid,
              let name = updatedPersistedData?.name,
              let email = updatedPersistedData?.email,
              let location = updatedPersistedData?.location,
              let accountType = updatedPersistedData?.accountType,
              let userType = updatedPersistedData?.userType,
              let hourlyRate = updatedPersistedData?.hourlyRate
        else { return }
        
        let fileName = "\(email)_\(UUID().uuidString)_changedProfileImage"
        StorageManager.shared.uploadProfilePicture(with: image, fileName: fileName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileImageUrl):
                let newData = UserPersistedInfo(uid: uid,
                                                name: name,
                                                email: email,
                                                location: location,
                                                accountType: accountType,
                                                profileImage: profileImageUrl,
                                                hourlyRate: hourlyRate,
                                                userType: userType)
                
                let updateElement = [
                    "profileImage": profileImageUrl
                ]
                
                self.database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("error changing database")
                        return
                    }
                    self.updatePersistedData(data: newData)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func changeUserProofOfExpertise(image: Data) {
        let updatedPersistedData = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
        
        guard let technicianKeyPath = updatedPersistedData?.uid else { return }
        guard let email = updatedPersistedData?.email else { return }
        let childPath = "users/technicians/\(technicianKeyPath)/profileInfo"
        
        let fileName = "\(email)_\(UUID().uuidString)_changedProofOfExpertise"
        StorageManager.shared.uploadProofOfExpertise(with: image, fileName: fileName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let proofOfExpertiseUrl):
                
                let updateElement = [
                    "proofOfExpertise": proofOfExpertiseUrl
                ]
                
                self.database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("error changing database")
                        return
                    }
                })
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updatePersistedData(data: UserPersistedInfo) {
        updatePersistedData = data
        self.defaults.set(object: updatePersistedData, forKey: "persistUsersInfo")
        print("newData: ", updatePersistedData)
        self.getUsersPersistedInfo = data
        self.tableView.reloadData()
    }
    
    func fetchSelectedAddress(address: String, lat: Double, long: Double) {
        let location = UserPersistedLocation(address: address, lat: lat, long: long)
        changeUserLocation(location: location)
    }

}

// MARK: - UIImagePickerControllerDelegate Extension
extension TechnieEditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        isProofOfExpertiseTapped = false
        isProofOfExpertiseFileSelected = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
                
        if isProofOfExpertiseTapped == true {
            
            if let image = info[.originalImage] as? UIImage {
                // Convert selectedImage into Data type
                if let selectedImage = image.jpegData(compressionQuality: 0.5) {//image.pngData()
                    changeUserProofOfExpertise(image: selectedImage)
                    self.isProofOfExpertiseFileSelected = true
                    self.tableView.reloadData()
                }
            }
            
            isProofOfExpertiseTapped = false

        } else {
            
            if let image = info[.editedImage] as? UIImage, let imageData =  image.jpegData(compressionQuality: 0.8) {
                newProfileImage = imageData
                changeUserProfileImage(image: imageData)
                self.tableView.reloadData()
            }
            
        }
        
    }
}
