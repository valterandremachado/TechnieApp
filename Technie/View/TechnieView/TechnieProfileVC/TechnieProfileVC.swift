//
//  TechnieProfileVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit
import FirebaseAuth
import MessageUI

class TechnieProfileVC: UIViewController {
        
    let stringArray = ["Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala"]
    let detailArray = ["LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala"]
    let imageArray = ["person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill"]
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .white
        tv.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        tv.tableFooterView = UIView()
        
//        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
//        tv.layer.cornerRadius = 18
        tv.clipsToBounds = true
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(TechineProfileTVCell.self, forCellReuseIdentifier: TechineProfileTVCell.cellID)
        return tv
    }()
    
    var sections = [SectionHandler]()
    
    var getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
//    var userPersistedName = ""
//    var userPersistedLocation = ""
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
        
        sections.append(SectionHandler(title: "UserInfo", detail: [""]))
        sections.append(SectionHandler(title: "AccountInfo", detail: ["", "", ""]))
        sections.append(SectionHandler(title: "Share and Help", detail: ["", "", ""]))
        sections.append(SectionHandler(title: "Logout", detail: [""]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchSavedJobs(notification:)), name: NSNotification.Name("SavedJobsNotificationObserver"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchSavedJobs(notification:)), name: NSNotification.Name("updatePersistedData"), object: nil)

    }
        
//    @objc func fetchSavedJobs(notification: NSNotification) {
////        guard let jobs = notification.object as? [PostModel] else { return }
////        userSavedJobs  = jobs
//        print("Value of notification : ", notification.object)
//    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
                
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        updateProfileImage()
        setupNavBar()
    }
    
    var tempImage = UIImage().resizeImage(image: UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.systemGray6, renderingMode: .alwaysOriginal) ?? UIImage(), toTheSize: CGSize(width: 40, height: 40))

    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Settings"
        navBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func updateProfileImage() {
        let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
        let userPersistedProfileImage = getUsersPersistedInfo?.profileImage ?? ""

        UrlImageLoader.sharedInstance.imageForUrl(urlString: userPersistedProfileImage) { (image, url) in
            guard let actualProfileImage = image else { return }
            self.tempImage = UIImage().resizeImage(image: actualProfileImage, toTheSize: CGSize(width: 40, height: 40))
//            self.tableView.reloadData()
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
//            print(url)
        }
    }
    
    // MARK: - Selectors
    
    
}

// MARK: - TechnieEditProfileVCDismissalDelegate Extension
extension TechnieProfileVC: TechnieEditProfileVCDismissalDelegate {
    
    func TechnieEditProfileVCDismissalSingleton(updatedPersistedData: UserPersistedInfo) {
        guard !updatedPersistedData.uid.isEmpty else { return }
        getUsersPersistedInfo = updatedPersistedData
//        print("updatedPersistedData2: \(getUsersPersistedInfo)")
//        userPersistedName = getUsersPersistedInfo?.first?.name ?? "username"
//        userPersistedLocation = getUsersPersistedInfo?.first?.location ?? "userlocation"
        updateProfileImage()
        tableView.reloadData()
    }
    
}


// MARK: - TableViewDelegateAndDataSource Extension
extension TechnieProfileVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count //stringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TechineProfileTVCell.cellID, for: indexPath) as! TechineProfileTVCell
        // Enables detailTextLabel visibility
        cell = TechineProfileTVCell(style: .subtitle, reuseIdentifier: TechineProfileTVCell.cellID)
        
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        let lastIndex = lastRowIndex - 1
        
        // Customize Cell
        //        cell.textLabel?.textColor = .black
        //        cell.detailTextLabel?.textColor = .black
        //        cell.backgroundColor = .white
        
//        let tableViewOptions = TechnieProfileTVOptions(rawValue: indexPath.row)
        switch indexPath.section {
        case 0:
            var getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")

//            let userName = UserDefaults.standard.value(forKey: "email") as? String ?? ""
            let userPersistedName = getUsersPersistedInfo?.name ?? "username"
            let userPersistedLocation = getUsersPersistedInfo?.location.address ?? "userlocation"
            let userPersistedProfileImage = getUsersPersistedInfo?.profileImage ?? ""
//            let profileImageUrl = URL(string: userPersistedProfileImage)
            
            cell.textLabel?.font = .boldSystemFont(ofSize: 16)
            cell.textLabel?.text = userPersistedName 
            cell.detailTextLabel?.text = userPersistedLocation
//            let newImage = UIImage().resizeImage(image: UIImage(named: "technie")!, toTheSize: CGSize(width: 40, height: 40))
//            var actualImage = UIImage()
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.cornerRadius = 40 / 2
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.backgroundColor = .systemGray6
            cell.imageView?.image = tempImage
            
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            
        case 1:
            let tableViewOptions = TechnieProfileTVOptions0(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)

        case 2:
            let tableViewOptions = TechnieProfileTVOptions1(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)

        case 3:
            let tableViewOptions = TechnieProfileTVOptions2(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            indexPath.row == lastIndex ? (cell.accessoryType = .none) : (cell.accessoryType = .disclosureIndicator)
            indexPath.row == lastIndex ? (cell.textLabel?.textColor = .red) : (cell.textLabel?.textColor = .black)
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)

        default:
            break
        }
        // Pass data
//        cell.textLabel?.text = tableViewOptions?.description
//        //        cell.detailTextLabel?.text = detailArray[indexPath.row]
//        cell.imageView?.image = tableViewOptions?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let vc = TechnieEditProfileVC()
            vc.dismissalDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            if indexPath.row == 0 {
                let vc = TechnieAccountVC()
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                let vc = TechnieSavedJobsVC()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = TechnieStatsVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if indexPath.row == 0 {
                let vc = TechnieGeneralVC()
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                showMailComposer()
            } else {
                presentShareSheet()
            }
         
        case 3:
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
        
//        let indexedUrl = favoritedPostArray[indexPath.item].sourceUrl
//        guard let url = URL(string: "https://www.google.com") else { return }
        let textToShare = "Hey, Technie is a fast, simple and secure app that I use to boost up my freelancing career. Give it a try."
        let thingsToShare: [Any] = [textToShare]
        
        let shareSheetVC = UIActivityViewController(activityItems: thingsToShare , applicationActivities: nil)
//        shareSheetVC.popoverPresentationController?.sourceView = self.view
        present(shareSheetVC, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section > 0 {
//            return sections[section].sectionTitle
//        }
//        return ""
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .white

        let headerLabel = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.width, height: 30))
        headerLabel.textColor = .systemGray
       
        if section > 0 {
            headerLabel.text = ""//sections[section].sectionTitle
            headerView.addSubview(headerLabel)
            
            return headerView
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
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

// MARK: - MFMailComposeViewControllerDelegate Extension
extension TechnieProfileVC: MFMailComposeViewControllerDelegate {
    
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


// MARK: - TechnieProfileVCPreviews
import SwiftUI

struct TechnieProfileVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = TechnieProfileVC()
        return vc.liveViewController
    }
    
}
