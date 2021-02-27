//
//  TechnieNotificationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit
import FirebaseDatabase

class TechnieNotificationVC: UIViewController {

    var userNotifications = NotificationModel()
    
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
    var postChildPath = "nil"

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        fetchData()
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
                self.userNotifications = notifications
                self.tableView.reloadData()
                print("success")
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Selectors
    @objc func declineBtnPressed() {
      
    }
    
    @objc func acceptBtnPressed() {
        print("this: \(postChildPath)")
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        guard let hiredTechnicanEmail = getUsersPersistedInfo.first?.email else { return }
        guard let technicianChildPath = getUsersPersistedInfo.first?.uid else { return }
        
        let upadateElement = [
            "availabilityStatus": false,
            "hiringStatus": [
                "isHired": true,
                "technicianToHireEmail": hiredTechnicanEmail,
                "date": PostFormVC.dateFormatter.string(from: Date())
            ]
        ] as [String : Any]
        
        self.database.child("\(postChildPath)").updateChildValues(upadateElement, withCompletionBlock: { error, _ in
            if error != nil {
                print("error on hiring: \(error?.localizedDescription ?? "nil")")
                return
            }
            
            self.database.child("users/technicians/\(technicianChildPath)/hiredJobs").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                guard let self = self else { return }
                
                if var hiredJobsCollection = snapshot.value as? [[String: Any]] {
                    // append to user dictionary
                    let newElement = [
                        [
                            "postChildPath": self.postChildPath,
                            "isCompleted": false
                        ]
                    ]
                    
                    hiredJobsCollection.append(contentsOf: newElement)
                    self.database.child("users/technicians/\(technicianChildPath)/hiredJobs").setValue(hiredJobsCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                        
                    })
                } else {
                    // create that array
                    let newElement = [
                        [
                            "postChildPath": self.postChildPath,
                            "isCompleted": false
                        ]
                    ]
                    
                    self.database.child("users/technicians/\(technicianChildPath)/hiredJobs").setValue(newElement, withCompletionBlock: { error, _ in
                    })
                }
            })
        })
    }
    
//    let notifications = ["technie", "client", "technie", "client", "technie", "client", "technie", "client", "technie"]
}

// MARK: - Extension
extension TechnieNotificationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNotifications.notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TechnieNotificationsCell.cellID, for: indexPath) as! TechnieNotificationsCell
        
        let model = userNotifications.notifications?[indexPath.row]
        if model?.type == "Hiring" {
            postChildPath = model?.postChildPath ?? "nil"
            cell.declineBtn.addTarget(self, action: #selector(declineBtnPressed), for: .touchUpInside)
            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnPressed), for: .touchUpInside)
            cell.setupViews2()
            cell.userNotification = model
        } else {
            cell.setupViews()
            cell.userNotification = model
        }
        return cell
    }
    
    
    
}
