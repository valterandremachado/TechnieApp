//
//  TechnieServiceVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit

class TechnieServiceVC: UIViewController {
        
    // MARK: - Properties
    var sections = [SectionHandler]()
    var activeJobsModel = [PostModel]()
    var previousJobsModel = [PostModel]()
    var hiredJobsPostUID = [String]()
    
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
        
        tv.register(ActiveJobsTVCell.self, forCellReuseIdentifier: ActiveJobsTVCell.cellID)
        tv.register(PreviousJobsTVCell.self, forCellReuseIdentifier: PreviousJobsTVCell.cellID)
        return tv
    }()
    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    let sectionTitle = ["Active Jobs", "Previous Jobs"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
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
        [tableView].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Contracts"
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
    }
    
    fileprivate func fetchData()  {
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        guard let technicianKeyPath = getUsersPersistedInfo.first?.uid else { return }
        
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
                        self.tableView.reloadData()
                        //                                    print("jobs: \(self.postModel)")
                        return
                    case .failure(let error):
                        print("Failed to get posts: \(error.localizedDescription)")
                    }
                })
                
            case .failure(let error):
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
                        self.tableView.reloadData()
                        return
                    case .failure(let error):
                        print("Failed to get posts: \(error.localizedDescription)")
                    }
                })
                
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Selectors
    
    
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
            let model = activeJobsModel[indexPath.row]

            var cell = tableView.dequeueReusableCell(withIdentifier: ActiveJobsTVCell.cellID, for: indexPath) as! ActiveJobsTVCell
            cell = ActiveJobsTVCell(style: .subtitle, reuseIdentifier: ActiveJobsTVCell.cellID)
//            cell.selectionStyle = .none
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.textColor = .systemGray
            cell.detailTextLabel?.text = "Hired \(view.calculateTimeFrame(initialTime: model.dateTime))"
            cell.accessoryType = .detailButton
            return cell
        case 1:
            let modelTwo = previousJobsModel[indexPath.row]

            var cell = tableView.dequeueReusableCell(withIdentifier: PreviousJobsTVCell.cellID, for: indexPath) as! PreviousJobsTVCell
            cell = PreviousJobsTVCell(style: .subtitle, reuseIdentifier: PreviousJobsTVCell.cellID)

            cell.selectionStyle = .none
            cell.detailTextLabel?.textColor = .systemGray
            cell.detailTextLabel?.text = "Hired \(view.calculateTimeFrame(initialTime: modelTwo.dateTime))"
            cell.textLabel?.text = modelTwo.title
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
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        guard let technicanName = getUsersPersistedInfo.first?.name else { return }
        guard let technicianKeyPath = getUsersPersistedInfo.first?.uid else { return }


        DatabaseManager.shared.getHiredJobs(techniciankeyPath: technicianKeyPath) { success in
            switch success {
            case .success(let hiredJobs):
                for job in hiredJobs {
                    if job.postChildPath == postChildPath {
                        let hiredJobKeyPath = job.id
                        let technieHiredJobsChildPath = "users/technicians/\(technicianKeyPath)/hiredJobs/\(hiredJobKeyPath ?? "")"
                        
                        DatabaseManager.shared.markAJobAsDone(withTechnieHiredJobsChildPath: technieHiredJobsChildPath, withPostChildPath: postChildPath, clientKeyPath: model.postOwnerInfo!.keyPath, technicianName: technicanName, completedJobUID: jobID) { success in
                            if success {
                                guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
                                guard let technicianKeyPath = getUsersPersistedInfo.first?.uid else { return }
                                
                                self.getPreviousHiredJobs(technicianKeyPath: technicianKeyPath)
                                
                                self.activeJobsModel.remove(at: indexPath.row)
                                self.tableView.beginUpdates()
                                self.tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
                                self.tableView.endUpdates()
                                return
                            }
                        }
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

