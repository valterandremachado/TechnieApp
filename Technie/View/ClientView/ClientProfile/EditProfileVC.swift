//
//  EditProfileVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/16/21.
//

import UIKit

class EditProfileVC: UIViewController {

    // MARK: - Properties
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
    
    // MARK: - Selectors
    
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension EditProfileVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.cellID, for: indexPath) as! EditProfileCell
        
        switch indexPath.row {
        case 0:
            cell.setupProfilePhotoStackView()
        case 1:
            cell.setupDisplayNameStackView()
        case 2:
            cell.setupLocationStackView()
        case 3:
            cell.setupAccountStackView()
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
            print("DisplayName")
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
            print("camera")
        }
        
        let gallery = UIAlertAction(title: "Select from Gallery", style: .default) { (_) in
            print("gallery")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(camera)
        alertController.addAction(gallery)
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
        
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
//            guard let firstNameField = alertController.textFields?[0] else { return }
//            guard let lastNameField = alertController.textFields?[1] else { return }
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
        
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
//            guard let firstNameField = alertController.textFields?[0] else { return }
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

