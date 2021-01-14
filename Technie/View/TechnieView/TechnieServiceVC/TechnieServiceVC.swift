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
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.dataSource = self
        tv.register(ActiveJobsTVCell.self, forCellReuseIdentifier: ActiveJobsTVCell.cellID)
        tv.register(PreviousJobsTVCell.self, forCellReuseIdentifier: PreviousJobsTVCell.cellID)
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
        
        sections.append(SectionHandler(title: "Active Jobs", detail: ["Active 1", "Active 2", "Active 3", "Active 4"]))
        sections.append(SectionHandler(title: "Previous Jobs", detail: ["previous 1", "previous 2", "previous 3", "previous 4", "previous 5", "previous 6"]))
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
    
    // MARK: - Selectors
    
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnieServiceVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count//handymanSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitles =  sections[indexPath.section]
        let title = sectionTitles.sectionDetail[indexPath.row]
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActiveJobsTVCell.cellID, for: indexPath) as! ActiveJobsTVCell
            cell.selectionStyle = .none
            cell.textLabel?.text = title
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PreviousJobsTVCell.cellID, for: indexPath) as! PreviousJobsTVCell
            cell.selectionStyle = .none
            cell.textLabel?.text = title
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    
//        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return sections[section].sectionTitle
//        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .white
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: -15, width: tableView.frame.width - 15, height: 40))
        headerLabel.textColor = .systemGray
        headerLabel.text = sections[section].sectionTitle
        headerView.addSubview(headerLabel)
        return headerView
    }
    
}

