//
//  TechnieEditProfile.swift
//  Technie
//
//  Created by Valter A. Machado on 2/18/21.
//

import UIKit

class TechnieEditProfileVC: UIViewController {

    // MARK: - Properties
    var newProfileImage = Data()
    var newUserName = ""
    var newLocation = ""
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TechnieEditProfileCell.cellID, for: indexPath) as! TechnieEditProfileCell
        
        switch indexPath.row {
        case 0:
            var userProfileImage = UIImage(named: "technieDummyPhoto")
            let uploadedUserProfileImage = UIImage(data: newProfileImage)
            uploadedUserProfileImage == nil ? (userProfileImage = userProfileImage) : (userProfileImage = uploadedUserProfileImage)

            cell.setupViewsOne()
            cell.titleLabel.text = "Profile Photo"
            cell.profileImageView.image = userProfileImage
            
        case 1:
            var userDisplayName = ""
            newUserName == "" ? (userDisplayName = "username") : (userDisplayName = newUserName)
            cell.titleLabel.text = "Display Name"
            cell.descriptionLabel.text = userDisplayName
            
        case 2:
            var userLocation = ""
            newLocation == "" ? (userLocation = "Baguio city") : (userLocation = newLocation)
            cell.titleLabel.text = "Location"
            cell.descriptionLabel.text = userLocation

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
            presentChangeLocationAlertController()
        default:
            break
        }
    }
    
    fileprivate func presentChangePhotoAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
//            let imagePicker = UIImagePickerController()
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.delegate = self
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true)
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
    
    fileprivate func presentChangeLocationAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let enterLocation = UIAlertAction(title: "Enter Location", style: .default) { [self] (_) in
            print("enterLocation")
            presentEnterLocationAlertController()
        }
        
        let phoneLocation = UIAlertAction(title: "Use Phone's Location", style: .default) { (_) in
            print("phoneLocation")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(enterLocation)
        alertController.addAction(phoneLocation)
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
    
    fileprivate func presentEnterLocationAlertController() {
        var locationField = UITextField()
        locationField.placeholder = "New Location"

        let alertController = UIAlertController(title: "Enter Location", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let locationInput = alertController.textFields?[0] else { return }
            newLocation = locationInput.text!
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.placeholder = "New Location"
            locationField = addTextField
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
extension TechnieEditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
            newProfileImage = imageData
            self.tableView.reloadData()
        }
    }
}
