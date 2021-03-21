//
//  TechnieServiceVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit
import FirebaseDatabase

class TechnieServiceVC: UIViewController {
        
    // MARK: - Properties
    var sections = [SectionHandler]()
    var activeJobsModel = [PostModel]()
    var previousJobsModel = [PostModel]()
    var hiredJobsPostUID = [String]()
    
    lazy var refresher: UIRefreshControl = {
        let rc = UIRefreshControl()
//        rc.isEnabled = false
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
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
        tv.refreshControl = refresher
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
        tv.contentInsetAdjustmentBehavior = .never
        
        tv.register(ActiveJobsTVCell.self, forCellReuseIdentifier: ActiveJobsTVCell.cellID)
        tv.register(PreviousJobsTVCell.self, forCellReuseIdentifier: PreviousJobsTVCell.cellID)
        return tv
    }()
    
    let sectionTitle = ["Active Jobs", "Previous Jobs"]

    lazy var warningLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "You haven't been hired yet, keep applying."
        return lbl
    }()
    
    private var indicator: ProgressIndicatorLarge!

    var database = Database.database().reference()
    var technicianModel: TechnicianModel?

    var updatedActiveServices = 0
    var updatedCompletedServices = 0
    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        fetchData()
        setupViews()
        
//        sections.append(SectionHandler(title: "Active Jobs", detail: ["Active 1", "Active 2", "Active 3", "Active 4"]))
//        sections.append(SectionHandler(title: "Previous Jobs", detail: ["previous 1", "previous 2", "previous 3", "previous 4", "previous 5", "previous 6"]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print("viewWillAppear")
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        setupNavBar()
        [tableView, indicator].forEach { view.addSubview($0)}
        indicator.start()
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Contracts"
        navBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func getTechnicianInfo() {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid

        DatabaseManager.shared.getSpecificTechnician(technicianKeyPath: technicianKeyPath) { result in
            switch result {
            case .success(let technicianInfo):
                self.technicianModel = technicianInfo
                
                self.updatedActiveServices = technicianInfo.numberOfActiveServices - 1
                self.updatedCompletedServices = technicianInfo.numberOfCompletedServices + 1
                
                self.updateActiveAndCompletedServices()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func updateActiveAndCompletedServices() {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid

//        guard let technicianInfo = self.technicianModel else { return }

        let updateElement = [
            "numberOfActiveServices": updatedActiveServices,
            "numberOfCompletedServices": updatedCompletedServices
        ] as [String : Any]
        
        
        let childPath = "users/technicians/\(technicianKeyPath)"
        self.database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            guard error == nil else {
                return
            }
        })
    }
    
    fileprivate func fetchData()  {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.getActiveHiredJobs(technicianKeyPath: technicianKeyPath)
            self.getPreviousHiredJobs(technicianKeyPath: technicianKeyPath)
        }
        
    }
    
    fileprivate func getActiveHiredJobs(technicianKeyPath: String) {
        DatabaseManager.shared.getAllActiveHiredJobs(techniciankeyPath: technicianKeyPath, completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let techniciansHiredJobsUID):
                //                        self.hiredJobsPostUID = technicians
                
                DatabaseManager.shared.getAllHiredJobs(technicianHiredJobKeyPaths: techniciansHiredJobsUID, completion: {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let posts):
                        let sortedArray = posts.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                        self.activeJobsModel = sortedArray
                        
                        self.warningLabel.isHidden = true
                        self.indicator.stop()
                        self.tableView.reloadData()
                        //                                    print("jobs: \(self.postModel)")
                        return
                        
                    case .failure(let error):
                        if self.activeJobsModel.count == 0 {
//                            self.tableView.isHidden = true
                            self.view.addSubview(self.warningLabel)
                            NSLayoutConstraint.activate([
                                self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                            ])
                        } else {
//                            self.tableView.isHidden = false
                        }
                        self.indicator.stop()
                        print("Failed to get posts: \(error.localizedDescription)")
                    }
                })
                
            case .failure(let error):
                if self.activeJobsModel.count == 0 {
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
    
    fileprivate func getPreviousHiredJobs(technicianKeyPath: String) {
        DatabaseManager.shared.getAllPreviousHiredJobs(techniciankeyPath: technicianKeyPath, completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let technicians):
                
                DatabaseManager.shared.getAllHiredJobs(technicianHiredJobKeyPaths: technicians, completion: {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let posts):
                        let sortedArray = posts.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                        self.previousJobsModel = sortedArray
                        
                        self.warningLabel.isHidden = true
                        self.indicator.stop()
                        self.tableView.reloadData()
                        return
                        
                    case .failure(let error):
                        print("Failed to get posts: \(error.localizedDescription)")
                    }
                })
                
            case .failure(let error):
                if self.activeJobsModel.count == 0 && self.previousJobsModel.count == 0 {
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
    
    fileprivate func refreshContractsData() {
        activeJobsModel.removeAll()
        previousJobsModel.removeAll()
        fetchData()
    }
    
    // MARK: - Selectors
    @objc func refreshData(_ refreshController: UIRefreshControl){
        
        DispatchQueue.main.async {
            self.refreshContractsData()
            let refreshDeadline = DispatchTime.now() + .seconds(Int(2))
            DispatchQueue.main.asyncAfter(deadline: refreshDeadline) {
                refreshController.endRefreshing()
            }
        }
        
    }
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnieServiceVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[section].sectionDetail.count//handymanSectionArray.count
        if section == 0 {
            return activeJobsModel.count
        } else {
            return previousJobsModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let sectionTitles =  sections[indexPath.section]
//        let title = sectionTitles.sectionDetail[indexPath.row]

        switch indexPath.section {
        case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: ActiveJobsTVCell.cellID, for: indexPath) as! ActiveJobsTVCell
            cell = ActiveJobsTVCell(style: .subtitle, reuseIdentifier: ActiveJobsTVCell.cellID)
            
            if activeJobsModel.count != 0 {
                let model = activeJobsModel[indexPath.row]
                //            cell.selectionStyle = .none
                cell.textLabel?.text = model.title
                cell.detailTextLabel?.textColor = .systemGray
                cell.detailTextLabel?.text = "Hired \(view.calculateTimeFrame(initialTime: model.dateTime))"
                cell.accessoryType = .detailButton
            }
            return cell
        case 1:

            var cell = tableView.dequeueReusableCell(withIdentifier: PreviousJobsTVCell.cellID, for: indexPath) as! PreviousJobsTVCell
            cell = PreviousJobsTVCell(style: .subtitle, reuseIdentifier: PreviousJobsTVCell.cellID)

            if previousJobsModel.count != 0 {
                let modelTwo = previousJobsModel[indexPath.row]
                cell.selectionStyle = .none
                cell.detailTextLabel?.textColor = .systemGray
                cell.detailTextLabel?.text = "Hired \(view.calculateTimeFrame(initialTime: modelTwo.dateTime))"
                cell.textLabel?.text = modelTwo.title
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presentAccessoryButtonAlert(indexPath: indexPath)
    }
    
    fileprivate func presentAccessoryButtonAlert(indexPath: IndexPath) {
        print(indexPath.row)
        let alertController = UIAlertController(title: "Info", message: nil, preferredStyle: .alert)
        
        let markAsCompletedAction = UIAlertAction(title: "Mark as completed", style: .default) { action in
            self.markJobAsCompleted(indexPath: indexPath)
            self.getTechnicianInfo()
        }
        
        let viewPostAction = UIAlertAction(title: "View job details", style: .default) { [self] action in
            let vc = JobDetailsVC()
            vc.postModel = activeJobsModel[indexPath.row]
            vc.navBarViewSubtitleLbl.text = "posted \(view.calculateTimeFrame(initialTime: activeJobsModel[indexPath.row].dateTime))"
            vc.isComingFromServiceVC = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(markAsCompletedAction)
        alertController.addAction(viewPostAction)
        alertController.addAction(cancelAction)
        alertController.fixActionSheetConstraintsError()
        present(alertController, animated: true)
    }

    fileprivate func markJobAsCompleted(indexPath: IndexPath) {
        let model = activeJobsModel[indexPath.row]
        guard let jobID = model.id else { return }
        let postChildPath = "posts/\(jobID)"
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicanName = getUsersPersistedInfo.name
        let technicianKeyPath = getUsersPersistedInfo.uid

        
        self.activeJobsModel.remove(at: indexPath.row)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
        self.tableView.endUpdates()
        
        var isCompleted = false
        
        DatabaseManager.shared.getHiredJobs(techniciankeyPath: technicianKeyPath) { success in
            switch success {
            case .success(let hiredJobs):
                for job in hiredJobs { 
                    if job.postChildPath == postChildPath && isCompleted == false {
                        let hiredJobKeyPath = job.id
                        let technieHiredJobsChildPath = "users/technicians/\(technicianKeyPath)/hiredJobs/\(hiredJobKeyPath ?? "")"
                        
                        DatabaseManager.shared.markAJobAsDone(withTechnieHiredJobsChildPath: technieHiredJobsChildPath, withPostChildPath: postChildPath, clientKeyPath: model.postOwnerInfo!.keyPath, technicianName: technicanName, completedJobUID: jobID) { success in
                            if success {
                                guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
                                let technicianKeyPath = getUsersPersistedInfo.uid
                                self.getPreviousHiredJobs(technicianKeyPath: technicianKeyPath)
                            }
                        }
                        
                        isCompleted = true
                        
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return activeJobsModel.isEmpty ? (nil) : (sectionTitle[0])
        } else {
            return previousJobsModel.isEmpty ? (nil) : (sectionTitle[1])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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

