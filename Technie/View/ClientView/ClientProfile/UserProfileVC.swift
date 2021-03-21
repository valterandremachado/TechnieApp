//
//  UserProfileVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/17/20.
//

import UIKit
import MessageUI
import FirebaseAuth

class UserProfileVC: UIViewController {
        
    let stringArray = ["Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala"]
    let detailArray = ["LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala"]
    let imageArray = ["person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill"]
    
    // MARK: - Properties
    var getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .systemBackground
        
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
//        tv.layer.cornerRadius = 18
        tv.clipsToBounds = true

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.cellID)
        return tv
    }()
    
    lazy var profileImageView: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        iv.roundedImage()
//        iv.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        //        iv.sizeToFit()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter A. Machado"
        lbl.textAlignment = .center
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City, Philippines"
        lbl.textAlignment = .center
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 13)
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
//        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var stackView1: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, locationLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 0
        sv.distribution = .equalSpacing
        return sv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        profileImageViewPicker.roundedImage()
//    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView, profileImageView, stackView1].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        
        stackView1.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 35))
        
        tableView.anchor(top: stackView1.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
//        guard let navBar = navigationController?.navigationBar else { return }
        let userPersistedName = getUsersPersistedInfo?.name ?? "username"
        
        let delimiter = " "
        let slicedString = userPersistedName.components(separatedBy: delimiter)[1]
        navigationItem.title = "@\(slicedString.lowercased())"
        
        fetchUserInfo()
    }
    
    fileprivate func fetchUserInfo() {
        let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
        let userPersistedName = getUsersPersistedInfo?.name ?? "username"
        let userPersistedLocation = getUsersPersistedInfo?.location.address ?? "userlocation"
        let userPersistedProfileImage = getUsersPersistedInfo?.profileImage ?? "image"
        let profileImageUrl = URL(string: userPersistedProfileImage)
        
        nameLabel.text = userPersistedName
        locationLabel.text = userPersistedLocation
        profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
        
        //        UrlImageLoader.sharedInstance.imageForUrl(urlString: userPersistedProfileImage) { (image, url) in
        //            self.profileImageView.image = image
        //        }
    }
    
    // MARK: - Selectors


}

// MARK: - EditProfileVCDismissalDelegate Extension
extension UserProfileVC: EditProfileVCDismissalDelegate {
    
    func EditProfileVCDismissalSingleton(updatedPersistedData: UserPersistedInfo) {
        
        guard !updatedPersistedData.uid.isEmpty else { return }
        let userPersistedName = updatedPersistedData.name
        let userPersistedLocation = updatedPersistedData.location
        let userPersistedProfileImage = getUsersPersistedInfo?.profileImage ?? ""
        let profileImageUrl = URL(string: userPersistedProfileImage)
        
        nameLabel.text = userPersistedName
        locationLabel.text = userPersistedLocation.address
        profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
        getUsersPersistedInfo = updatedPersistedData
    }
    
}


// MARK: - TableViewDelegateAndDataSource Extension
extension UserProfileVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 //stringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.cellID, for: indexPath) as! ProfileTableViewCell
        // Enables detailTextLabel visibility
        cell = ProfileTableViewCell(style: .subtitle, reuseIdentifier: ProfileTableViewCell.cellID)
        cell.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)

        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        let lastIndex = lastRowIndex - 1
        
        // Customize Cell
//        cell.textLabel?.textColor = .black
//        cell.detailTextLabel?.textColor = .black
//        cell.backgroundColor = .white
        indexPath.row == lastIndex ? (cell.textLabel?.textColor = .red) : (cell.textLabel?.textColor = .black)
        indexPath.row == lastIndex ? (cell.accessoryType = .none) : (cell.accessoryType = .disclosureIndicator)
        let tableViewOptions = TableViewOptions(rawValue: indexPath.row)
        // Pass data
        cell.textLabel?.text = tableViewOptions?.description
//        cell.detailTextLabel?.text = detailArray[indexPath.row]
        cell.imageView?.image = tableViewOptions?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = EditProfileVC()
            vc.dismissalDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = ClientPostHistoryVC()
            navigationController?.pushViewController(vc, animated: true)
        //            let vc = TechnieTabController()
        //            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        case 2:
            print("help")
            showMailComposer()
        case 3:
            print("tell a friend")
            presentShareSheet()
        case 4:
            let vc = ClientSettingsVC()
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            print("log out")
            presentAlertSheetForLogBtn()
            
        default:
            break
        }
      
    }
    
    
    fileprivate func presentAlertSheetForLogBtn() {
        let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
        guard let currentUserName = getUsersPersistedInfo?.name else { return }
        
        let alertController = UIAlertController(title: "Log out of \(currentUserName)?", message: nil, preferredStyle: .alert)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let mainVC = ChooseAccountTypeVC()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UINavigationController(rootViewController: mainVC))
            } catch let signOutError as NSError {
                print ("Error signing out: ", signOutError)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    fileprivate func presentShareSheet() {
        
        let textToShare = "Hey, Technie is a fast, simple and secure app that I use to hire technicians from my town. Give it a try."
        let thingsToShare: [Any] = [textToShare]
        
        let shareSheetVC = UIActivityViewController(activityItems: thingsToShare , applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    
}

// MARK: - MFMailComposeViewControllerDelegate Extension
extension UserProfileVC: MFMailComposeViewControllerDelegate {
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["support@technie.com"])
        composer.setSubject("HELP!")
        composer.setMessageBody("", isHTML: false)
        
        present(composer, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}

// MARK: - UserProfileVCPreviews
import SwiftUI

struct UserProfileVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = UserProfileVC()
        return vc.liveViewController
    }
    
}
