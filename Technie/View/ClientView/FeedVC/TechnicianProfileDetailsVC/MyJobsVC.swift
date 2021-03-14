//
//  MyJobsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/26/21.
//

import UIKit
import FirebaseDatabase

// Singleton
protocol MyJobsVCDismissalDelegate: class {
    func jobsVCDismissalSingleton(isDismissed withIsDone: Bool)
}

class MyJobsVC: UIViewController {
    
    fileprivate var defaults = UserDefaults.standard
    var selectedIndexes = [IndexPath]()
    var posts = [PostModel]()
    var userPostModel = [PostModel]()
    var technicianModel: TechnicianModel!
    
    weak var myJobsVCDismissalDelegate: MyJobsVCDismissalDelegate?

    // MARK: - Properties
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
        tv.contentInsetAdjustmentBehavior = .never
        
        tv.register(MyJobsCell.self, forCellReuseIdentifier: MyJobsCell.cellID)
        return tv
    }()
    
    private let database = Database.database().reference()
    
    var isSentByDeclineAction = false
    var isSendingInvitation = false

    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    var postWithInvitation = [PostModel]()
    var postWithNOInvitation = [PostModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        if isSendingInvitation == true {
            // Check if the technician was already invited to apply for this job (display only the jobs he/she wasn't invited)
            userPostModel.forEach { post in
                let invites = post.invitations
                if invites == nil {
                    posts.append(post)
                    print("invites is nil: ", post.title)
                } else {
                    postWithInvitation.append(post)
                    if self.postWithInvitation.filter({($0.invitations?.contains(where: {$0.technicianEmail.contains(technicianModel.profileInfo.email)}))!}).isEmpty
                    {   // append to array only if there's no match in this condition
                        posts.append(contentsOf: postWithInvitation)
                    }
                }
            }
            
        } else {
            posts = userPostModel
        }
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        for i in 0..<tableView.numberOfSections {
//            for j in 0..<tableView.numberOfRows(inSection: i) {
//                let indexPath = IndexPath(row: j, section: i)
//            }
//        } // End of loop
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        setupNavBar()
        [tableView].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftNavBarBtnTapped))
        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightNavBarBtnTapped))
        
        if isSentByDeclineAction == true {
            navigationItem.title = "Hired Jobs"
            self.navigationItem.leftBarButtonItem = leftNavBarButton
        } else {
            if isSendingInvitation != true {
                navigationItem.title = "Jobs"
                self.navigationItem.leftBarButtonItem = leftNavBarButton
                self.navigationItem.rightBarButtonItem = rightNavBarButton
            } else {
                let rightNavBarButtonForInvitaion = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightNavBarBtnForInvitaionTapped))
                navigationItem.title = "Jobs"
                self.navigationItem.leftBarButtonItem = leftNavBarButton
                self.navigationItem.rightBarButtonItem = rightNavBarButtonForInvitaion
            }
        }
        
    }
    
    fileprivate func presentAlertSheetForPullbackHiring() {
        let alertController = UIAlertController(title: "Decline Hiring", message: "Are you sure you want to turn down this hire?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [self] (_) in
            
            for indexPath in selectedIndexes {
                let newCell = tableView.cellForRow(at: indexPath)
                if newCell?.accessoryType == UITableViewCell.AccessoryType.none
                {
                    newCell?.accessoryType = .checkmark
                    selectedIndexes.append(indexPath)
                } else {
                    guard let removeThisIndexPath = selectedIndexes.firstIndex(of: indexPath) else { return }
                    newCell?.accessoryType = .none
                    selectedIndexes.remove(at: removeThisIndexPath)
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    fileprivate func presentAlertSheetForSelectionOfJobs() {
        let alertController = UIAlertController(title: "Oops!", message: "You have not assign any job to this technician. Please press cancel instead.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    fileprivate func sendInvitation(with selectedIndexPaths: [IndexPath]) {
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let clientName = getUsersPersistedInfo.name
        let clientEmail = getUsersPersistedInfo.email
        let clientKeyPath = getUsersPersistedInfo.uid
        var postModel = [PostModel]()
        
        for indexPath in selectedIndexPaths {
            postModel.append(posts[indexPath.row])
        }
        
        for post in postModel {
            if let postID = post.id {
                print("postID: \(postID)")
                let childPath = "posts/\(postID)"
                // create that array
                insertInvitation(postID: postID)
                //                        print("try: \(error?.localizedDescription ?? "N/A")")
                let clientInfo = ClientInfo(name: clientName,
                                            email: clientEmail,
                                            keyPath: clientKeyPath)
                let notification = TechnicianNotificationModel(id: "nil",
                                                               type: TechnicianNotificationType.jobInvitation.rawValue,
                                                               title: TechnicianNotificationType.jobInvitation.rawValue,
                                                               description: "\(clientName) is inviting you to apply to his job post.",
                                                               dateTime: PostFormVC.dateFormatter.string(from: Date()),
                                                               postChildPath: childPath,
                                                               clientInfo: clientInfo)

                DatabaseManager.shared.insertTechnicianNotification(with: notification, with: self.technicianModel.profileInfo.email, completion: { success in
                    if success {
                        print("success")
                    } else {
                        print("failed")
                    }
                })
            }
        }
    }
    
    fileprivate func updatePost(with selectedIndexPaths: [IndexPath]) {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let clientName = getUsersPersistedInfo.name
        let clientEmail = getUsersPersistedInfo.email
        let clientKeyPath = getUsersPersistedInfo.uid
        var postModel = [PostModel]()
        
        for indexPath in selectedIndexPaths {
            postModel.append(posts[indexPath.row])
        }
        
            for post in postModel {
                if let postID = post.id {
                    print("postID: \(postID)")
                    let childPath = "posts/\(postID)"
                    // create that array
                    let upadateElement = [ // pass the info to the technician and when he/she accepts the hiring update this element
                        "hiringStatus": [
                            "isHired": false,
                            "technicianToHireEmail": technicianModel.profileInfo.email,
                            "technicianKeyPath": technicianModel.profileInfo.id,
                            "date": PostFormVC.dateFormatter.string(from: Date())
                        ]
                    ] as [String : Any]
                    
                    self.database.child("\(childPath)").updateChildValues(upadateElement, withCompletionBlock: { error, _ in
                        if error != nil {
                            print("error on hiring: \(error?.localizedDescription ?? "nil")")
                            return
                        }
//                        print("try: \(error?.localizedDescription ?? "N/A")")
                        let clientInfo = ClientInfo(name: clientName,
                                                    email: clientEmail,
                                                    keyPath: clientKeyPath)
                        let notification = TechnicianNotificationModel(id: "nil",
                                                                       type: TechnicianNotificationType.hiringOffer.rawValue,
                                                                       title: TechnicianNotificationType.hiringOffer.rawValue,
                                                                       description: "\(clientName) wants to hire you as a technician to do a service at his place.",
                                                                       dateTime: PostFormVC.dateFormatter.string(from: Date()),
                                                                       postChildPath: childPath,
                                                                       clientInfo: clientInfo)
                        
                        DatabaseManager.shared.insertTechnicianNotification(with: notification, with: self.technicianModel.profileInfo.email, completion: { success in
                            if success {
                                print("success")
                            } else {
                                print("failed")
                            }
                        })

                    })
                }
            }
    }
    
    fileprivate func insertInvitation(postID: String) {
        let technicianEmail = technicianModel.profileInfo.email
        let technicanUID = technicianModel.profileInfo.id
        
        let childPath = "posts/\(postID)"
//        database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            self.database.child("\(childPath)/invitations").observeSingleEvent(of: .value, with: { snapshot in
                
                if var postsCollection = snapshot.value as? [[String: Any]] {
                    // append to user dictionary
                    let newElement = [
                        [
                            "technicianUID": technicanUID,
                            "technicianEmail": technicianEmail,
                        ]
                    ]
                    
                    postsCollection.append(contentsOf: newElement)
                    self.database.child("\(childPath)/invitations").setValue(postsCollection, withCompletionBlock: { error, _ in
                        guard error == nil else { return }
                    })
                    
                } else {
                    // create that array
                    let newElement = [
                        [
                            "technicianUID": technicanUID,
                            "technicianEmail": technicianEmail,
                        ]
                    ]
                    
                    self.database.child("\(childPath)/invitations").setValue(newElement, withCompletionBlock: { error, _ in
                    })
                }
            })
//        })
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightNavBarBtnTapped() {
        if selectedIndexes.count == 0 {
            presentAlertSheetForSelectionOfJobs()
        } else {
            sendInvitation(with: selectedIndexes)
            updatePost(with: selectedIndexes)
            dismiss(animated: true, completion: nil)
            myJobsVCDismissalDelegate?.jobsVCDismissalSingleton(isDismissed: true)
        }
    }
    
    @objc fileprivate func rightNavBarBtnForInvitaionTapped() {
        if selectedIndexes.count == 0 {
            presentAlertSheetForSelectionOfJobs()
        } else {
            sendInvitation(with: selectedIndexes)
            dismiss(animated: true, completion: nil)
        }
    }
    
        
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension MyJobsVC: TableViewDataSourceAndDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MyJobsCell.cellID, for: indexPath) as! MyJobsCell
        cell = MyJobsCell(style: .subtitle, reuseIdentifier: MyJobsCell.cellID)
        let model = posts[indexPath.row]
        cell.userPostModel = model
        
        if technicianModel.profileInfo.email == model.hiringStatus?.technicianToHireEmail && model.hiringStatus?.isHired == true && isSentByDeclineAction == true {
            cell.accessoryType = .checkmark
            selectedIndexes.append(indexPath)
        } else  if technicianModel.profileInfo.email == model.hiringStatus?.technicianToHireEmail && model.hiringStatus?.isHired == true && isSentByDeclineAction == false {
            cell.accessoryType = .checkmark
        }
        
        //        if indexPath == selectedIndexPath {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // do nothing if the cell is checked already
//        if indexPath == selectedIndexPath { return }

        // toggle old one off and the new one on
        let newCell = tableView.cellForRow(at: indexPath)
        if newCell?.accessoryType == UITableViewCell.AccessoryType.none
        && isSentByDeclineAction == false {
            newCell?.accessoryType = .checkmark
            selectedIndexes.append(indexPath)
        } else {
            guard let removeThisIndexPath = selectedIndexes.firstIndex(of: indexPath) else { return }
            let model = posts[indexPath.row]
            if technicianModel.profileInfo.email == model.hiringStatus?.technicianToHireEmail && model.hiringStatus?.isHired == true && isSentByDeclineAction == true  {
                presentAlertSheetForPullbackHiring()
            } else {
                newCell?.accessoryType = .none
                selectedIndexes.remove(at: removeThisIndexPath)
            }
           
        }
        print("didSelectRowAt: \(selectedIndexes)")
       
       

//        let oldCell = tableView.cellForRow(at: selectedIndexPath!)
//        if oldCell?.accessoryType == .checkmark
//        {
//            oldCell?.accessoryType = .none
//        }
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

// MARK: - MyJobsVCPreviews
import SwiftUI

struct MyJobsVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = MyJobsVC()
        return vc.liveViewController
    }
    
}
