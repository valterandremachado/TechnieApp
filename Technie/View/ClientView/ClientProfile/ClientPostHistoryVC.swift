//
//  ClientPostsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/16/21.
//

import UIKit

class ClientPostHistoryVC: UIViewController {

    // MARK: - Properties
    var sections = [SectionHandler]()
    
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
        tv.isHidden = true
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
        tv.contentInsetAdjustmentBehavior = .never
        
        tv.register(ClientPostHistoryCell.self, forCellReuseIdentifier: ClientPostHistoryCell.cellID)
//        tv.register(PreviousJobsTVCell.self, forCellReuseIdentifier: PreviousJobsTVCell.cellID)
        return tv
    }()
    
    lazy var warningLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "You haven't posted any service yet."
        return lbl
    }()
    
    private var indicator: ProgressIndicatorLarge!

    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        sections.append(SectionHandler(title: "Active Posts", detail: ["Active 1", "Active 2", "Active 3", "Active 4"]))
        sections.append(SectionHandler(title: "Previous Posts", detail: ["previous 1", "previous 2", "previous 3", "previous 4", "previous 5", "previous 6"]))
        
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
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
        indicator.start()

        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
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
//        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Service History"
    }
    
    var posts = [PostModel]()
    var activePosts = [PostModel]()
    var previousPosts = [PostModel]()
    
    fileprivate func fetchData() {
        DatabaseManager.shared.getClientActiveAndPreviousPosts { result in
            switch result {
            case .success(let activePosts):
                self.activePosts = activePosts
                
                if self.activePosts.count == 0 && self.previousPosts.count == 0 {
                    self.tableView.isHidden = true
                    self.view.addSubview(self.warningLabel)
                    NSLayoutConstraint.activate([
                        self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    ])
                } else {
                    self.tableView.isHidden = false
                }
                self.indicator.stop()
                self.tableView.reloadData()
            case .failure(let error):
                if self.activePosts.count == 0 && self.previousPosts.count == 0 {
                    self.tableView.isHidden = true
                    self.view.addSubview(self.warningLabel)
                    NSLayoutConstraint.activate([
                        self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    ])
                } else {
                    self.tableView.isHidden = false
                }
                print(error)
            }
        } completionOnPreviousPosts: { result in
            switch result {
            case .success(let previousPosts):
                self.previousPosts = previousPosts
                
                if self.activePosts.count == 0 && self.previousPosts.count == 0 {
                    self.tableView.isHidden = true
                    self.view.addSubview(self.warningLabel)
                    NSLayoutConstraint.activate([
                        self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    ])
                } else {
                    self.tableView.isHidden = false
                }
                self.indicator.stop()
                self.tableView.reloadData()
            case .failure(let error):
                if self.activePosts.count == 0 && self.previousPosts.count == 0 {
                    self.tableView.isHidden = true
                    self.view.addSubview(self.warningLabel)
                    NSLayoutConstraint.activate([
                        self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    ])
                } else {
                    self.tableView.isHidden = false
                }
                self.indicator.stop()
                print(error)
            }
        }

    }
    
    // MARK: - Selectors
    
    let repairerSectionArray = ["Refrigerator Repair", "Washing Machine Repair", "Freezer Repair", "Ice Cream Machine Repair", "TV Repair", "Microwave Repair", "Heat Pump Repair", "Commercial Oven Repair", "Dryer Machine Repair", "Others"]
    
    let handymanSectionArray = ["Plumbing Installation/Leaking Plumbing", "Drywall Installation", "Fixture Replacement", "Painting for the Interior and Exterior", "Power Washing", "Tile Installation", "Deck/Door/Window Repair", "Carpenter", "Cabinetmaker", "Others"]
    
    let electricianSectionArray = ["Refrigerator", "Drywall Installation", "Freezer", "Machine", "TV", "Microwave", "Pump", "Commercial", "Machine"]
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension ClientPostHistoryVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return activePosts.count
        } else {
            return previousPosts.count
        }
//        return sections[section].sectionDetail.count//handymanSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ClientPostHistoryCell.cellID, for: indexPath) as! ClientPostHistoryCell
        cell = ClientPostHistoryCell(style: .subtitle, reuseIdentifier: ClientPostHistoryCell.cellID)
                
        switch indexPath.section {
        case 0:
            let activePostsModel = activePosts[indexPath.row]
            cell.accessoryType = .detailButton
            cell.textLabel?.text = activePostsModel.title
            cell.detailTextLabel?.textColor = .systemGray
            cell.detailTextLabel?.text = "Posted \(view.calculateTimeFrame(initialTime: activePostsModel.dateTime))"
        case 1:
            let previousPostsModel = previousPosts[indexPath.row]

            cell.textLabel?.text = previousPostsModel.title
            cell.detailTextLabel?.textColor = .systemGray
            cell.detailTextLabel?.text = "Posted \(view.calculateTimeFrame(initialTime: previousPostsModel.dateTime))"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presentAccessoryButtonAlert(indexPath: indexPath)
    }
    
    fileprivate func presentAccessoryButtonAlert(indexPath: IndexPath) {
        print(indexPath.row)
        let alertController = UIAlertController(title: "Info", message: nil, preferredStyle: .alert)
        
        let editPostAction = UIAlertAction(title: "Edit Post", style: .default) { action in
            let postModel = self.activePosts[indexPath.row]
            let vc = PostFormVC()
            vc.titlePlaceHolderLabel.isHidden = true
            vc.descriptionPlaceHolderLabel.isHidden = true
            vc.isComingFromPostHistory = true
             
            vc.serviceField = postModel.field ?? "Others"
            vc.postModel = postModel
            var requiredSkills = postModel.requiredSkills
            requiredSkills.insert("", at: requiredSkills.count)
            vc.initialSelectedSkill = requiredSkills
            vc.titleTextField.text = postModel.title
            vc.descriptionTextField.text = postModel.description
            self.present(UINavigationController(rootViewController: vc), animated: true)
        }
        
        let viewPostAction = UIAlertAction(title: "View Post", style: .default) { [self] action in
            let vc = JobDetailsVC()
            vc.postModel = activePosts[indexPath.row]
            vc.navBarViewSubtitleLbl.text = "posted \(view.calculateTimeFrame(initialTime: activePosts[indexPath.row].dateTime))"
            vc.isComingFromServiceVC = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(editPostAction)
        alertController.addAction(viewPostAction)
        alertController.addAction(cancelAction)
        alertController.fixActionSheetConstraintsError()
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return activePosts.isEmpty ? (nil) : (sections[0].sectionTitle)
        } else {
            return previousPosts.isEmpty ? (nil) : (sections[1].sectionTitle)
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

