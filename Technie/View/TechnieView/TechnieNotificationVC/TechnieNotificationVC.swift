//
//  TechnieNotificationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit
import FirebaseDatabase

class TechnieNotificationVC: UIViewController {

    var userNotifications = [TechnicianNotificationModel]()
    var userPostModel: [PostModel] = []

    // MARK: - Properties
    lazy var refresher: UIRefreshControl = {
        let rc = UIRefreshControl()
//        rc.isEnabled = false
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
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
        tv.register(TechnieNotificationsCell.self, forCellReuseIdentifier: TechnieNotificationsCell.cellID)
        tv.register(TechnieNotificationsCellForBtns.self, forCellReuseIdentifier: TechnieNotificationsCellForBtns.cellID)
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

    var database = Database.database().reference()
    var postChildPath = ""

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        fetchUserPosts()
        fetchData()
        notificationChangesListener()
        setupViews()
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
        
        DatabaseManager.shared.getAllTechnicianNotifications(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notifications):
                let sortedArray = notifications.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                self.userNotifications = sortedArray
                
                self.indicator.stop()
                self.tableView.reloadData()
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
                self.tableView.reloadData()
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func notificationChangesListener() {
        DatabaseManager.shared.listenToTechnicianNotificationChanges(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notifications):
                self.userNotifications.removeAll()
                print("childChanged")
                let sortedArray = notifications.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                self.userNotifications = sortedArray
                self.tableView.reloadData()
                return
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func refreshNotificationData() {
        DatabaseManager.shared.getAllTechnicianNotifications(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notifications):
                self.userNotifications.removeAll()
                let sortedArray = notifications.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                self.userNotifications = sortedArray
                self.tableView.reloadData()
//                self.refresher.endRefreshing()
                print("success")
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func fetchUserPosts()  {
        DatabaseManager.shared.getAllPosts(completion: { result in
            switch result {
            case .success(let userPosts):
                self.userPostModel = userPosts
//                    print("userPosts: ", self.userPostModel)
                                
            case .failure(let error):
                print("userPosts: ", error)

                print(error)
            }
        })
    }
    
    // MARK: - Selectors
    @objc func declineBtnPressed(sender: UIButton) {
        let index = sender.tag
        let indexedNotificationModel = userNotifications[index]
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicanName = getUsersPersistedInfo.name
        let technicianKeyPath = getUsersPersistedInfo.uid
        guard let clientKeyPath = indexedNotificationModel.clientInfo?.keyPath else { return }
        guard let postChildPath = indexedNotificationModel.postChildPath else { return }

        let technieChildPathToDelete = "users/technicians/\(technicianKeyPath)/notifications/\(indexedNotificationModel.id)"
//        print("model: \(indexedNotificationModel), childPath: \(technieChildPathToDelete), tag: \(sender.tag)")
        let clientPostChildPathToDelete = "\(postChildPath)/hiringStatus"

        DatabaseManager.shared.deleteNotification(withTechnieChildPath: technieChildPathToDelete, withPostChildPath: clientPostChildPathToDelete, clientKeyPath: clientKeyPath, technicianName: technicanName, completion: { success in
            if success {
                print("notification deleted")
                self.userNotifications.remove(at: index)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
                self.tableView.endUpdates()

            } else {
                print("failed to delete notification")
            }
        })
    }
    
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
        guard let name = userNotifications[indexedTag].clientInfo?.name else { return }
        guard let email = userNotifications[indexedTag].clientInfo?.email else { return }
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
    var selectedIndex = IndexPath()
}

// MARK: - Extension
extension TechnieNotificationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = userNotifications[indexPath.row]
        if model.type == TechnicianNotificationType.hiringOffer.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: TechnieNotificationsCellForBtns.cellID, for: indexPath) as! TechnieNotificationsCellForBtns

            cell.postChildPath = model.postChildPath ?? ""

            cell.acceptBtn.tag = indexPath.row
            cell.declineBtn.tag = indexPath.row
            cell.startChatBtn.tag = indexPath.row
            cell.declineBtn.addTarget(self, action: #selector(declineBtnPressed), for: .touchUpInside)
            cell.startChatBtn.addTarget(self, action: #selector(startChatBtnPressed), for: .touchUpInside)
            cell.userNotification = model
            
            switch model.type {
            case TechnicianNotificationType.hiringOffer.rawValue:
                cell.titleLabel.text = "Hiring Offer"

            case TechnicianNotificationType.jobInvitation.rawValue:
                cell.titleLabel.text = "Invitation"

            case TechnicianNotificationType.closedJob.rawValue:
                cell.titleLabel.text = "Closing Job"
            default:
                break
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TechnieNotificationsCell.cellID, for: indexPath) as! TechnieNotificationsCell

            cell.userNotification = model
            
            switch model.type {
            case TechnicianNotificationType.hiringOffer.rawValue:
                cell.titleLabel.text = "Hiring Offer"

            case TechnicianNotificationType.jobInvitation.rawValue:
                cell.titleLabel.text = "Invitation"

            case TechnicianNotificationType.closedJob.rawValue:
                cell.titleLabel.text = "Closing Job"
            default:
                break
            }
        
            return cell
        }
        
        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let notificationModel = userNotifications[indexPath.row]
        
        let delimiter = "posts/"
        let postUID = notificationModel.postChildPath?.components(separatedBy: delimiter)[1]
        if notificationModel.type == TechnicianNotificationType.jobInvitation.rawValue {
            let vc = JobDetailsVC()
            userPostModel.forEach { post in
                if post.id == postUID {
                    vc.isComingFromSavedJobsVC = true
                    vc.postModel = post
                    vc.navBarViewSubtitleLbl.text = "posted \(view.calculateTimeFrame(initialTime: post.dateTime))"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
           
        }
    }
    
    
}
