//
//  TechnieSavedJobsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/18/21.
//

import UIKit

class TechnieSavedJobsVC: UIViewController {

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
        tv.contentInsetAdjustmentBehavior = .automatic
        
        tv.register(TechnieSavedJobsCell.self, forCellReuseIdentifier: TechnieSavedJobsCell.cellID)
        return tv
    }()
    
    lazy var warningLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "You have no saved jobs."
        return lbl
    }()
    
    var savedJobs = [PostModel]()

    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        fetchData()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print("viewWillAppear")
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Saved Jobs"
    }
    
    fileprivate func fetchData()  {
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        guard let technicianKeyPath = getUsersPersistedInfo.first?.uid else { return }
        
        DispatchQueue.main.async {
            DatabaseManager.shared.getAllSavedJobs(technicianKeyPath: technicianKeyPath) { [self] result in
                switch result {
                case .success(let savedJobs):
                    self.savedJobs = savedJobs
                    
                    if savedJobs.count == 0 {
                        tableView.isHidden = true
                        view.addSubview(warningLabel)
                        NSLayoutConstraint.activate([
                            warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                        ])
                    } else {
                        tableView.isHidden = false
                    }
                    
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Selectors
    
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnieSavedJobsVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TechnieSavedJobsCell.cellID, for: indexPath) as! TechnieSavedJobsCell
        cell = TechnieSavedJobsCell(style: .subtitle, reuseIdentifier: TechnieSavedJobsCell.cellID)
        let model = savedJobs[indexPath.row]
        cell.detailTextLabel?.textColor = .systemGray
        cell.detailTextLabel?.text = "Posted \(view.calculateTimeFrame(initialTime: model.dateTime))"
        cell.textLabel?.text = model.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = JobDetailsVC()
        vc.isComingFromSavedJobsVC = true
        vc.postModel = savedJobs[indexPath.row]
        vc.navBarViewSubtitleLbl.text = "posted \(view.calculateTimeFrame(initialTime: savedJobs[indexPath.row].dateTime))"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove bottom extra 20px space.
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}

