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
        return tv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
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
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
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
                self.tableView.reloadData()
                print("success")
            case .failure(let error):
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
                self.tableView.reloadData()
                self.refresher.endRefreshing()
                print("success")
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Selectors
    @objc func refreshData(_ refreshController: UIRefreshControl){
//        let refreshDeadline = DispatchTime.now() + .seconds(Int(1.5))
        DispatchQueue.main.async {
            self.refreshNotificationData()
//            refreshController.endRefreshing()
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

// MARK: - Extension
extension ClientNotificationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClientNotificationCell.cellID, for: indexPath) as! ClientNotificationCell
        let model = userNotifications[indexPath.row]
        cell.userNotification = model
        cell.startChatBtn.tag = indexPath.row
        if model.wasAccepted == true {
            cell.setupViews2()
            cell.buttonsStackView.isHidden = false
            cell.startChatBtn.addTarget(self, action: #selector(startChatBtnPressed), for: .touchUpInside)
        } else {
            cell.buttonsStackView.isHidden = true
            cell.setupViews()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationModel = userNotifications[indexPath.row]
//        let postModel = userPostModel[indexPath.row]
//        let technieModel = technicianModel[indexPath.row]

        if notificationModel.type == ClientNotificationType.proposal.rawValue {
            
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
            
        } else {
            let vc = ReviewTechnicianVC()
            present(UINavigationController(rootViewController: vc), animated: true)
            
        }
    }
    
    
}
