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
    
    private var indicator: ProgressIndicatorLarge!

    var savedJobs = [PostModel]()

    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        if savedJobs.count == 0 {
            indicator.start()
        }
        
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
        [tableView, indicator].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
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
//        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Saved Jobs"
    }
    
    
    fileprivate func fetchData()  {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid
        
        DispatchQueue.main.async {
            DatabaseManager.shared.getAllSavedJobs(technicianKeyPath: technicianKeyPath) { [self] result in
                switch result {
                case .success(let savedJobs):
                    self.savedJobs = savedJobs
                    
                    indicator.stop()
                    self.tableView.reloadData()
                case .failure(let error):
                    
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
                    
                    indicator.stop()
                    
                    self.tableView.reloadData()
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
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presentAlertForSavedJobsRemoval(indexPath: indexPath)
    }
    
    fileprivate func presentAlertForSavedJobsRemoval(indexPath: IndexPath){
        guard let userPersistedData = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }

        let model = savedJobs[indexPath.row]
        let technicianKeyPath = userPersistedData.uid
        let savedJobKeyPath = model.id ?? ""
        let childPathToDelete = "users/technicians/\(technicianKeyPath)/savedJobs/\(savedJobKeyPath)"

        let alertController = UIAlertController(title: "Remove saved job post?", message: nil, preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (_) in
            DatabaseManager.shared.deleteChildPath(withChildPath: childPathToDelete) { success in
                if success {
                    self.savedJobs.remove(at: indexPath.row)
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
                    self.tableView.endUpdates()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = savedJobs[indexPath.row]

        let vc = JobDetailsVC()
        if model.availabilityStatus != true {
            vc.isComingFromServiceVC = true
        } else {
            vc.isComingFromSavedJobsVC = true
        }

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

