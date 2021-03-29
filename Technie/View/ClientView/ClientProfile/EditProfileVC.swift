//
//  EditProfileVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/16/21.
//

import UIKit
import FirebaseDatabase

protocol EditProfileVCDismissalDelegate: class {
    func EditProfileVCDismissalSingleton(updatedPersistedData: UserPersistedInfo)
}

class EditProfileVC: UIViewController, SelectedLocationDelegate {
    

    // MARK: - Properties
    let database = Database.database().reference()
    fileprivate var defaults = UserDefaults.standard
    var updatePersistedData: UserPersistedInfo?
    var getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")

    weak var dismissalDelegate: EditProfileVCDismissalDelegate?

    var newProfileImage = Data()
    var newUserName = ""
    var newLocation = ""
    
    var sections = [SectionHandler]()
    
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
        
        tv.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCell.cellID)
        return tv
    }()
    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let newData = updatePersistedData else { return }
        dismissalDelegate?.EditProfileVCDismissalSingleton(updatedPersistedData: newData)
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
//        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Edit Profile"
    }
    
    // Database updates
    private func changeUserName(name: String) {
        let updatedPersistedData = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")

        guard let technicianKeyPath = updatedPersistedData?.uid else { return }
        let childPath = "users/clients/\(technicianKeyPath)/profileInfo"

        guard let uid = updatedPersistedData?.uid,
              let email = updatedPersistedData?.email,
              let location = updatedPersistedData?.location,
              let userType = updatedPersistedData?.userType,
              let profileImage = updatedPersistedData?.profileImage
        else { return }
        
        let newData = UserPersistedInfo(uid: uid,
                                  name: name,
                                  email: email,
                                  location: location,
                                  accountType: nil,
                                  profileImage: profileImage,
                                  hourlyRate: nil,
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
        let childPath = "users/clients/\(technicianKeyPath)/profileInfo"

        guard let uid = updatedPersistedData?.uid,
              let name = updatedPersistedData?.name,
              let email = updatedPersistedData?.email,
              let userType = updatedPersistedData?.userType,
              let profileImage = updatedPersistedData?.profileImage
        else { return }
        
        let newData = UserPersistedInfo(uid: uid,
                                  name: name,
                                  email: email,
                                  location: location,
                                  accountType: nil,
                                  profileImage: profileImage,
                                  hourlyRate: nil,
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
        guard let clientKeyPath = updatedPersistedData?.uid else { return }
        let childPath = "users/clients/\(clientKeyPath)/profileInfo"

        guard let uid = updatedPersistedData?.uid,
              let name = updatedPersistedData?.name,
              let email = updatedPersistedData?.email,
              let userType = updatedPersistedData?.userType,
              let location = updatedPersistedData?.location
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
                                          accountType: nil,
                                          profileImage: profileImageUrl,
                                          hourlyRate: nil,
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
    
    private func updatePersistedData(data: UserPersistedInfo) {
        updatePersistedData = data
        self.defaults.set(object: updatePersistedData, forKey: "persistUsersInfo")
//        print("newData: ", updatePersistedData)
        self.getUsersPersistedInfo = data
        self.tableView.reloadData()
    }
    
    func fetchSelectedAddress(address: String, lat: Double, long: Double) {
        let location = UserPersistedLocation(address: address, lat: lat, long: long)
        changeUserLocation(location: location)
    }
    
    // MARK: - Selectors
    
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension EditProfileVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.cellID, for: indexPath) as! EditProfileCell
        
        let persistedUserName = getUsersPersistedInfo?.name ?? "username"
        let persistedLocation = getUsersPersistedInfo?.location.address ?? "userlocation"
        let persistedEmail = getUsersPersistedInfo?.email ?? "username@gmail.com"
        let userPersistedProfileImage = getUsersPersistedInfo?.profileImage ?? ""
        let profileImageUrl = URL(string: userPersistedProfileImage)

        switch indexPath.row {
        case 0:
//            var userProfileImage = UIImage(named: "technieDummyPhoto")
            let uploadedUserProfileImage = UIImage(data: newProfileImage)
            
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
            cell.titleLabel.text = "Account"
            cell.descriptionLabel.text = persistedEmail
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
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
        default:
            break
        }
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
    
}

// MARK: - UIImagePickerControllerDelegate Extension
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage, let imageData =  image.jpegData(compressionQuality: 0.8) {//image.pngData()
            newProfileImage = imageData
            changeUserProfileImage(image: imageData)
            self.tableView.reloadData()
        }
    }
}
