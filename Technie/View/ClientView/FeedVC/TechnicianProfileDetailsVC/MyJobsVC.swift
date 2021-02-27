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
    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print("viewWillAppear")
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        setupNavBar()
        [tableView].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationItem.title = "Jobs"
        navBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftNavBarBtnTapped))
        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightNavBarBtnTapped))

        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    fileprivate func fetchData()  {
        DatabaseManager.shared.getAllClientPosts(completion: { [self] result in
            switch result {
            case .success(let userPosts):
                userPostModel = userPosts
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightNavBarBtnTapped() {
        updatePost(with: selectedIndexes)
        dismiss(animated: true, completion: nil)
        myJobsVCDismissalDelegate?.jobsVCDismissalSingleton(isDismissed: true)
    }
    
    private let database = Database.database().reference()
    
    
    fileprivate func updatePost(with selectedIndexPaths: [IndexPath]) {
        var postModel = [PostModel]()
        
        for indexPath in selectedIndexPaths {
            postModel.append(userPostModel[indexPath.row])
        }
        
            for post in postModel {
                if let postID = post.id {
                    print("postID: \(postID)")
                    let childPath = "posts/\(postID)"
                    // create that array
                    let upadateElement = [ // pass the info to the technician and when he/she accepts the hiring update this element
                        "hiringStatus": [
                            "isHired": false,
                            "technicianToHireEmail": technicianModel.profileInfo.email
                        ]
                    ] as [String : Any]
                    
                    self.database.child("\(childPath)").updateChildValues(upadateElement, withCompletionBlock: { error, _ in
                        if error != nil {
                            print("error on hiring: \(error?.localizedDescription ?? "nil")")
                            return
                        }
//                        print("try: \(error?.localizedDescription ?? "N/A")")
                        let notification = TechnicianNotificationModel(type: "Hiring",
                                                                       title: "Hiring Notification",
                                                                       description: "he wants to hire you",
                                                                       dateTime: PostFormVC.dateFormatter.string(from: Date()),
                                                                       postChildPath: childPath)
                        
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
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension MyJobsVC: TableViewDataSourceAndDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MyJobsCell.cellID, for: indexPath) as! MyJobsCell
        cell = MyJobsCell(style: .subtitle, reuseIdentifier: MyJobsCell.cellID)
        let model = userPostModel[indexPath.row]
        cell.userPostModel = model
        print("userPostModel Count: \(userPostModel.count)")

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
        {
            newCell?.accessoryType = .checkmark
            selectedIndexes.append(indexPath)
        } else {
            guard let removeThisIndexPath = selectedIndexes.firstIndex(of: indexPath) else { return }
            newCell?.accessoryType = .none
            selectedIndexes.remove(at: removeThisIndexPath)
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
