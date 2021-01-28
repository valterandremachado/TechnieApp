//
//  ChatInfoVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/26/21.
//

import UIKit

class ChatInfoVC: UIViewController {

    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .white
        tv.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        tv.tableFooterView = UIView()
        
//        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
//        tv.layer.cornerRadius = 18
        tv.clipsToBounds = true
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
        tv.contentInsetAdjustmentBehavior = .never

        tv.delegate = self
        tv.dataSource = self
        tv.register(ChatInfoSectionOneCell.self, forCellReuseIdentifier: ChatInfoSectionOneCell.cellID)
        tv.register(ChatInfoSectionTwoCell.self, forCellReuseIdentifier: ChatInfoSectionTwoCell.cellID)
        tv.register(ChatInfoSectionThreeCell.self, forCellReuseIdentifier: ChatInfoSectionThreeCell.cellID)
        return tv
    }()
    
    var sections = [SectionHandler]()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        sections.append(SectionHandler(title: "User Info", detail: [""]))
        sections.append(SectionHandler(title: "Job Details", detail: ["Job Post", "Shared Photos", "Shared Location"]))
        sections.append(SectionHandler(title: "Other", detail: ["Report", "Delete conversation"]))
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
    }
    
    // MARK: - Methods
    func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    // MARK: - Selectors

}

// MARK: - Extension
extension ChatInfoVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Enables detailTextLabel visibility
        let sectionDetail = sections[indexPath.section].sectionDetail
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatInfoSectionOneCell.cellID, for: indexPath) as! ChatInfoSectionOneCell
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            cell.textLabel?.text = sectionDetail[indexPath.row]
//            cell = ChatInfoSectionOneCell(style: .subtitle, reuseIdentifier: TechineProfileTVCell.cellID)
            cell.selectionStyle = .none
            cell.setupViewsForCell()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatInfoSectionTwoCell.cellID, for: indexPath) as! ChatInfoSectionTwoCell
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = sectionDetail[indexPath.row]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatInfoSectionThreeCell.cellID, for: indexPath) as! ChatInfoSectionThreeCell
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = sectionDetail[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        headerView.backgroundColor = .clear

        let headerLabel = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.width, height: 35))
        headerLabel.textColor = .systemGray
        headerLabel.font = .systemFont(ofSize: 13)
        headerLabel.textAlignment = .left

        if section == 1 {
            headerLabel.text = sections[section].sectionTitle?.uppercased()
//            headerView.addBorder(.bottom, color: .lightGray, thickness: 0.25)
            headerView.addSubview(headerLabel)

            return headerView
        } else if section == 2 {

            headerLabel.text = ""
            headerView.addSubview(headerLabel)
            return headerView
        }

        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
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
