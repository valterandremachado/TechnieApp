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
    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        
        sections.append(SectionHandler(title: "Active Posts", detail: ["Active 1", "Active 2", "Active 3", "Active 4"]))
        sections.append(SectionHandler(title: "Previous Posts", detail: ["previous 1", "previous 2", "previous 3", "previous 4", "previous 5", "previous 6"]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print("viewWillAppear")
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Posts"
    }
    
    // MARK: - Selectors
    
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension ClientPostHistoryVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count//handymanSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ClientPostHistoryCell.cellID, for: indexPath) as! ClientPostHistoryCell
        cell = ClientPostHistoryCell(style: .subtitle, reuseIdentifier: ClientPostHistoryCell.cellID)
        
        let sectionTitles =  sections[indexPath.section]
        let title = sectionTitles.sectionDetail[indexPath.row]
        cell.textLabel?.text = title
        cell.detailTextLabel?.textColor = .systemGray
        cell.detailTextLabel?.text = "Description"

        return cell
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        headerView.backgroundColor = .white
        
        let headerLabel = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.width, height: 35))
        headerLabel.textColor = .systemGray
        headerLabel.font = .systemFont(ofSize: 13)
        headerLabel.text = sections[section].sectionTitle?.uppercased()
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

