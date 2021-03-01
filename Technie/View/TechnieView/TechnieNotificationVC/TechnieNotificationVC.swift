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

        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(TechnieNotificationsCell.self, forCellReuseIdentifier: TechnieNotificationsCell.cellID)
        return tv
    }()
    
    var database = Database.database().reference()
    var postChildPath = ""

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        fetchData()
        notificationChangesListener()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
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
                self.tableView.reloadData()
                print("success")
            case .failure(let error):
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
    
    // MARK: - Selectors
    @objc func declineBtnPressed(sender: UIButton) {
        let index = sender.tag
        let indexedNotificationModel = userNotifications[index]
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        guard let technicanName = getUsersPersistedInfo.first?.name else { return }
        guard let technicianKeyPath = getUsersPersistedInfo.first?.uid else { return }
        guard let clientKeyPath = indexedNotificationModel.clientKeyPath else { return }
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
    
    
//    let notifications = ["technie", "client", "technie", "client", "technie", "client", "technie", "client", "technie"]
    var selectedIndex = IndexPath()
}

// MARK: - Extension
extension TechnieNotificationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TechnieNotificationsCell.cellID, for: indexPath) as! TechnieNotificationsCell
        
        let model = userNotifications[indexPath.row]
        if model.type == "Hiring" {
//            postChildPath = model?.postChildPath ?? ""
            cell.postChildPath = model.postChildPath ?? ""

            cell.acceptBtn.tag = indexPath.row
            cell.declineBtn.tag = indexPath.row
            cell.declineBtn.addTarget(self, action: #selector(declineBtnPressed), for: .touchUpInside)
//            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnPressed), for: .touchUpInside)
            cell.setupViews2()
            cell.userNotification = model
            
        } else {
            cell.setupViews()
            cell.userNotification = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
    
}
