//
//  ClientNotificationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit

class ClientNotificationVC: UIViewController {

    var userNotifications = [ClientNotificationModel]()
    var technicianModel = [TechnicianModel]()
    var userPostModel = [PostModel]()

    lazy var refresher: UIRefreshControl = {
        let rc = UIRefreshControl()
//        rc.isEnabled = false
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .systemBackground
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.refreshControl = refresher
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ClientNotificationCell.self, forCellReuseIdentifier: ClientNotificationCell.cellID)
        tv.register(ClientNotificationCellForChatBtn.self, forCellReuseIdentifier: ClientNotificationCellForChatBtn.cellID)
        return tv
    }()
    
    lazy var warningLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "You have no notification to be shown."
        return lbl
    }()
    
    private var indicator: ProgressIndicatorLarge!
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        fetchUserPosts()
        fetchTechnician()
        fetchData()
        notificationChangesListener()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView, indicator].forEach {view.addSubview($0)}
        indicator.start()

        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.title = "Notifications"
    }
    
    fileprivate func fetchData() {
        DatabaseManager.shared.getAllClientNotifications(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notifications):
                let sortedArray = notifications.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                self.userNotifications = sortedArray
                
                self.indicator.stop()
                self.tableView.reloadData()
                print("success")
            case .failure(let error):
                if self.userNotifications.count == 0 {
//                    self.tableView.isHidden = true
                    self.view.addSubview(self.warningLabel)
                    NSLayoutConstraint.activate([
                        self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    ])
                } else {
//                    self.tableView.isHidden = false
                }

                self.indicator.stop()
                
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func notificationChangesListener() {
        DatabaseManager.shared.listenToClientNotificationChanges(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notifications):
                self.userNotifications.removeAll()
                print("childChanged")
                let sortedArray = notifications.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                self.userNotifications = sortedArray
                self.warningLabel.isHidden = true
                self.tableView.reloadData()
                return
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func fetchTechnician() {
        DatabaseManager.shared.getAllTechnicians(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let technicians):
                self.technicianModel.append(technicians)
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func fetchUserPosts()  {
        DatabaseManager.shared.getAllClientPosts(completion: { [self] result in
            switch result {
            case .success(let userPosts):
                userPostModel = userPosts
            case .failure(let error):
                print(error)
            }
        })
    }
    
    fileprivate func refreshNotificationData() {
        DatabaseManager.shared.getAllClientNotifications(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notifications):
                self.userNotifications.removeAll()
                let sortedArray = notifications.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                self.userNotifications = sortedArray
                self.warningLabel.isHidden = true
                self.tableView.reloadData()
                print("success")
            case .failure(let error):
                self.warningLabel.isHidden = false
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Selectors
    @objc func refreshData(_ refreshController: UIRefreshControl){

        DispatchQueue.main.async {
            self.refreshNotificationData()
            let refreshDeadline = DispatchTime.now() + .seconds(Int(2))
            DispatchQueue.main.asyncAfter(deadline: refreshDeadline) {
                refreshController.endRefreshing()
            }
        }
        
    }
    
    @objc func startChatBtnPressed(sender: UIButton) {
        let indexedTag = sender.tag
        guard let name = userNotifications[indexedTag].technicianInfo?.name else { return }
        guard let email = userNotifications[indexedTag].technicianInfo?.email else { return }
        createNewConversation(resultEmail: email,
                              resultName: name)
    }
    
    private func createNewConversation(resultEmail: String, resultName: String) {
        let name = resultName
        let email = DatabaseManager.safeEmail(emailAddress: resultEmail)

        // check in database if conversation with these two users exists
        // if it does, reuse conversation id
        // otherwise use existing code

        DatabaseManager.shared.conversationExists(with: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let convoId):
                print("success")
                let vc = ChatVC(with: email, id: convoId)
                vc.isNewConvo = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.present(UINavigationController(rootViewController: vc), animated: true)
            case .failure(let failure):
                print("failure: \(failure)")
                let vc = ChatVC(with: email, id: nil)
                vc.isNewConvo = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.present(UINavigationController(rootViewController: vc), animated: true)
            }
        })
    }
    
//    let notifications = ["technie", "client", "technie", "client", "technie", "client", "technie", "client", "technie"]
}

// MARK: - ReviewTechnicianVCDismissalDelegate Extension
extension ClientNotificationVC: ReviewTechnicianVCDismissalDelegate {
    
    func ReviewTechnicianVCDismissalSingleton(tappedRow: Int) {
        deleteIsReviewedNotification(index: tappedRow)
    }
    
    fileprivate func deleteIsReviewedNotification(index: Int) {
        let indexedNotificationModel = userNotifications[index]
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
//        let clientName = getUsersPersistedInfo.name
        let clientKeyPath = getUsersPersistedInfo.uid

        let ChildPathToDelete = "users/clients/\(clientKeyPath)/notifications/\(indexedNotificationModel.id)"

        DatabaseManager.shared.deleteChildPath(withChildPath: ChildPathToDelete, completion: { success in
            if success {
                print("notification deleted")
                self.userNotifications.remove(at: index)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.tableView.endUpdates()

            } else {
                print("failed to delete notification")
            }
        })
    }
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension ClientNotificationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ClientNotificationCell.cellID, for: indexPath) as! ClientNotificationCell
        let model = userNotifications[indexPath.row]

        if model.wasAccepted == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: ClientNotificationCellForChatBtn.cellID, for: indexPath) as! ClientNotificationCellForChatBtn

            cell.startChatBtn.tag = indexPath.row
            cell.userNotification = model
            cell.startChatBtn.addTarget(self, action: #selector(startChatBtnPressed), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ClientNotificationCell.cellID, for: indexPath) as! ClientNotificationCell
            cell.userNotification = model

//            cell.buttonsStackView.isHidden = true
            switch model.type {
            case ClientNotificationType.recommendation.rawValue:
                cell.titleLabel.text = "Recommendation"
                cell.titleLabel.isHidden = false

            case ClientNotificationType.proposal.rawValue:
                cell.titleLabel.text = "Proposal"
                cell.titleLabel.isHidden = false

            case ClientNotificationType.review.rawValue:
                cell.titleLabel.text = "Review"
                cell.titleLabel.isHidden = false
                
            default:
                cell.titleLabel.isHidden = true
                break
            }
            
            return cell
        }
        
//        if model.type == ClientNotificationType.recommendation.rawValue {
//            cell.titleLabel.text = "Recommendation"
//        }
        
 
        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationModel = userNotifications[indexPath.row]
//        let postModel = userPostModel[indexPath.row]
//        let technieModel = technicianModel[indexPath.row]

        switch notificationModel.type {
        case ClientNotificationType.proposal.rawValue:
            
            guard !technicianModel.isEmpty,
                  !userPostModel.isEmpty
            else { return }
            
            for technican in  technicianModel {
                for userPost in  userPostModel {
                    userPost.proposals?.forEach { proposal in
                        if proposal.technicianEmail == technican.profileInfo.email {
                            //                        print("proposal: \(userPost.proposals), email: \(technican.profileInfo.email)")
                            let vc = CoverLetterVC()
                            vc.titleLabel.text = "\(technican.profileInfo.name) cover letter"
                            vc.coverLetterLabel.text = proposal.coverLetter
                            vc.technicianModel = technican
                            present(UINavigationController(rootViewController: vc), animated: true)
                        }
                    }
                }
            }
            
        case ClientNotificationType.review.rawValue:
//            for post in userPostModel {
//                if notificationModel.completedJobUID == post.id {
                    let vc = ReviewTechnicianVC()
                    vc.isModalInPresentation = true
//                    vc.userPostModel = post
            vc.completedJobUID = notificationModel.completedJobUID ?? ""
                    vc.notificationRow = indexPath.row
                    vc.dismissalDelegate = self
                    present(UINavigationController(rootViewController: vc), animated: true)
                    return
//                }
//            }
            
        case ClientNotificationType.recommendation.rawValue:
            
            let vc = RecommendationVC()
            vc.userNotification = notificationModel
            vc.jobPostKeyPath = notificationModel.jobPostKeyPath ?? ""
            present(UINavigationController(rootViewController: vc), animated: true)
            
        default:
            break
        }
        
//        if notificationModel.type == ClientNotificationType.proposal.rawValue {
//            
//            guard !technicianModel.isEmpty,
//                  !userPostModel.isEmpty
//            else { return }
//            
//            for technican in  technicianModel {
//                for userPost in  userPostModel {
//                    userPost.proposals?.forEach { proposal in
//                        if proposal.technicianEmail == technican.profileInfo.email {
//                            //                        print("proposal: \(userPost.proposals), email: \(technican.profileInfo.email)")
//                            let vc = CoverLetterVC()
//                            vc.titleLabel.text = "\(technican.profileInfo.name) cover letter"
//                            vc.coverLetterLabel.text = proposal.coverLetter
//                            vc.technicianModel = technican
//                            present(UINavigationController(rootViewController: vc), animated: true)
//                        }
//                    }
//                }
//            }
//            
//        } else if notificationModel.type == ClientNotificationType.review.rawValue {
//            
//            for post in userPostModel {
//                if notificationModel.completedJobUID == post.id {
//                    let vc = ReviewTechnicianVC()
////                    vc.isModalInPresentation = true
//                    vc.userPostModel = post
//                    vc.notificationRow = indexPath.row
//                    vc.dismissalDelegate = self
//                    present(UINavigationController(rootViewController: vc), animated: true)
//                    return
//                }
//            }
//        }
        
        
    }
    
    
}
