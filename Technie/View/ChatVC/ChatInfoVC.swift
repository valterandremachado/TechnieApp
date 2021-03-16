//
//  ChatInfoVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/26/21.
//

import UIKit
import MessageUI

class ChatInfoVC: UIViewController {

    var convoSharedPhotoArray = [String]()
    var convoSharedLocationArray = [String]()

    // MARK: - Properties
    var conversations = [Conversation]()
    var convoID: String?
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .white
        tv.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        tv.tableFooterView = UIView()
        
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
        tv.contentInsetAdjustmentBehavior = .never

        tv.delegate = self
        tv.dataSource = self
        tv.register(ChatInfoSectionOneCell.self, forCellReuseIdentifier: ChatInfoSectionOneCell.cellID)
        tv.register(ChatInfoSectionTwoCell.self, forCellReuseIdentifier: ChatInfoSectionTwoCell.cellID)
        tv.register(ChatInfoSectionThreeCell.self, forCellReuseIdentifier: ChatInfoSectionThreeCell.cellID)
        return tv
    }()
    
    var sections = [SectionHandler]()
    let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        sections.append(SectionHandler(title: "User Info", detail: [""]))
        sections.append(SectionHandler(title: "Job Details", detail: ["Job Post", "Shared Photos", "Shared Location"]))
        sections.append(SectionHandler(title: "Other", detail: ["Report", "Delete conversation"]))
        
        switch getUsersPersistedInfo?.userType {
        case UserType.client.rawValue:
            fetchUserPostsClientSide()
            print("UserType.client")
            fetchAllTechnicians()
        case UserType.technician.rawValue:
            fetchUserPostsTechnieSide()
            print("UserType.technician")
            fetchAllClients()
        default:
            break
        }
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
        
    }
    
    // MARK: - Methods
    func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        setupNavBar()
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationItem.title = "Chat details"
        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func presentDeleteConvoAlertSheet() {
        let actionController = UIAlertController(title: "Delete conversation?", message: "This conversation will be deleted from your inbox. Other people will be able to see it.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self, let conversationId = self.convoID else { return }
           // TODO: Delete convo from firebase db
            // begin delete
//            let conversationId = conversations[indexPath.row].id
//            self.tableView.beginUpdates()
//            self.conversations.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .left)

            DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { success in
                if !success {
                    // add model and row back and show error alert
                }
                // Removes all the view from the navigation stack expect the root view (first-most view)
                self.navigationController?.popToRootViewController(animated: true)
            })
//            self.tableView.endUpdates()
        }
        
        actionController.addAction(cancelAction)
        actionController.addAction(deleteAction)
        present(actionController, animated: true)
    }
    
    var userPostModel = [PostModel]()
    var tempUserPostModel = [PostModel]()
    var technicianInfoModel: TechnicianModel?
    var clientInfoModel: ClientModel?
    var otherUserEmail = ""
    
    fileprivate func fetchUserPostsClientSide()  {
        DatabaseManager.shared.getAllPostsWithNoRestriction(completion: { [self] result in
            switch result {
            case .success(let userPosts):
                tempUserPostModel = userPosts
                tempUserPostModel.forEach { post in
                    if getUsersPersistedInfo?.email == post.postOwnerInfo?.email {
                        if post.availabilityStatus == false && otherUserEmail == post.hiringStatus?.technicianToHireEmail {
                            self.userPostModel.append(post)
                        }
                    }
                }
//                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    fileprivate func fetchUserPostsTechnieSide()  {
        DatabaseManager.shared.getAllPostsWithNoRestriction(completion: { [self] result in
            switch result {
            case .success(let userPosts):
                tempUserPostModel = userPosts
                tempUserPostModel.forEach { post in
                    if otherUserEmail == post.postOwnerInfo?.email {
                        if post.availabilityStatus == false && getUsersPersistedInfo?.email == post.hiringStatus?.technicianToHireEmail {
                            self.userPostModel.append(post)
                        }
                    }
                }
//                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    var otherUserImageUrl = ""
    var otherUserFetchedEmail = ""
    var otherUserName = ""

    fileprivate func fetchAllTechnicians()  {
        DatabaseManager.shared.getAllTechnicians(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let technicians):
                if technicians.profileInfo.email == self.otherUserEmail {
                    self.technicianInfoModel = technicians
                    self.otherUserImageUrl = technicians.profileInfo.profileImage ?? ""
                    self.otherUserFetchedEmail = technicians.profileInfo.email
                    self.otherUserName = technicians.profileInfo.name
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func fetchAllClients()  {
        DatabaseManager.shared.getAllClients(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let clients):
                if clients.profileInfo.email == self.otherUserEmail {
                    self.clientInfoModel = clients
                    self.otherUserImageUrl = clients.profileInfo.profileImage ?? ""
                    self.otherUserFetchedEmail = clients.profileInfo.email
                    self.otherUserName = clients.profileInfo.name
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Selectors

}

// MARK: - Extension
extension ChatInfoVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Enables detailTextLabel visibility
        let sectionDetail = sections[indexPath.section].sectionDetail

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatInfoSectionOneCell.cellID, for: indexPath) as! ChatInfoSectionOneCell
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            cell.textLabel?.text = sectionDetail[indexPath.row]
//            cell = ChatInfoSectionOneCell(style: .subtitle, reuseIdentifier: TechineProfileTVCell.cellID)
            cell.selectionStyle = .none
            cell.setupViewsForCell()
            
            cell.emailLabel.text = otherUserFetchedEmail
            cell.nameLabel.text = otherUserName
            cell.profileImageView.sd_setImage(with: URL(string: otherUserImageUrl), completed: nil)
                     
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatInfoSectionTwoCell.cellID, for: indexPath) as! ChatInfoSectionTwoCell
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = sectionDetail[indexPath.row]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatInfoSectionThreeCell.cellID, for: indexPath) as! ChatInfoSectionThreeCell
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = sectionDetail[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                if userPostModel.count == 1 {
                    guard let model = userPostModel.first else { return }
                    let vc = JobDetailsVC()
                    vc.postModel = model
                    vc.navBarViewSubtitleLbl.text = "posted \(view.calculateTimeFrame(initialTime: model.dateTime))"
                    vc.isComingFromServiceVC = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    print("its not 1: ", userPostModel.count)
                    let vc = JobsFromSameClientVC()
                    vc.userPostModel = userPostModel
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            } else if indexPath.row == 1 {
                let vc = PhotoCollectionViewerVC()
                vc.convoSharedPhotoArray = convoSharedPhotoArray
                vc.navigationItem.title = "Shared Photos"
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                let vc = LocationCollectionViewerVC()
                vc.convoSharedLocationArray = convoSharedLocationArray
                navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if indexPath.row == 1 {
                presentDeleteConvoAlertSheet()
            } else {
                showMailComposer()
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        headerView.backgroundColor = .clear

        let headerLabel = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.width, height: 35))
        headerLabel.textColor = .systemGray
        headerLabel.font = .systemFont(ofSize: 13)
        headerLabel.textAlignment = .left

        if section == 1 {
            headerLabel.text = sections[section].sectionTitle?.uppercased()
//            headerView.addBorder(.bottom, color: .lightGray, thickness: 0.25)
            headerView.addSubview(headerLabel)

            return headerView
        } else if section == 2 {

            headerLabel.text = ""
            headerView.addSubview(headerLabel)
            return headerView
        }

        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 35
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
extension ChatInfoVC: MFMailComposeViewControllerDelegate {
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["report@technie.com"])
        composer.setSubject("Reporting technican (\(technicianInfoModel?.profileInfo.email ?? ""))!")
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


