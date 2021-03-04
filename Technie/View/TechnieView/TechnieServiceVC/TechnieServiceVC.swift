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
        DispatchQueue.main.async {
            
            guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
//            guard let technicanName = getUsersPersistedInfo.first?.name else { return }
            guard let technicianKeyPath = getUsersPersistedInfo.first?.uid else { return }
//            guard let clientKeyPath = indexedNotificationModel.clientInfo?.keyPath else { return }
//            guard let postChildPath = indexedNotificationModel.postChildPath else { return }
            
            DatabaseManager.shared.getAllSpecificTechnician(techniciankeyPath: technicianKeyPath, completion: {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let technicians):
//                        self.hiredJobsPostUID = technicians
                        
                            DatabaseManager.shared.getAllHiredJobs(technicianHiredJobKeyPaths: technicians, completion: {[weak self] result in
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
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let sectionTitles =  sections[indexPath.section]
//        let title = sectionTitles.sectionDetail[indexPath.row]
        let model = activeJobsModel[indexPath.row]
        switch indexPath.section {
        case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: ActiveJobsTVCell.cellID, for: indexPath) as! ActiveJobsTVCell
            cell = ActiveJobsTVCell(style: .subtitle, reuseIdentifier: ActiveJobsTVCell.cellID)
            cell.selectionStyle = .none
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.textColor = .systemGray
            cell.detailTextLabel?.text = "hired \(view.calculateTimeFrame(initialTime: model.dateTime))"

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PreviousJobsTVCell.cellID, for: indexPath) as! PreviousJobsTVCell
            cell.selectionStyle = .none
//            cell.textLabel?.text = title
            return cell
        default:
            return UITableViewCell()
        }
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        headerView.backgroundColor = .white
        
        let headerLabel = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.width, height: 35))
        headerLabel.textColor = .systemGray
        headerLabel.font = .systemFont(ofSize: 13)
        headerLabel.text = sectionTitle[section].uppercased()
        headerView.addSubview(headerLabel)
        return headerView
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

