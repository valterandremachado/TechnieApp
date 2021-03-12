//
//  ClientSettingsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/16/21.
//

import UIKit

class ClientSettingsVC: UIViewController {

    let defaults = UserDefaults.standard
    
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
        tv.contentInsetAdjustmentBehavior = .automatic
        
        tv.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.cellID)
        return tv
    }()
    
    var switcherIsOn = false

    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
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
        navigationItem.title = "Settings"
    }
    
    // MARK: - Selectors
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension ClientSettingsVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.cellID, for: indexPath) as! SettingsCell
        
        switch indexPath.row {
//        case 0:
//            cell.setupSwitcherStackView()
//            cell.titleLabel.text = "In-App Notification"
        case 0:
            cell.setupSwitcherStackView()
            cell.switcher.tag = indexPath.row
            cell.switcher.isOn = defaults.bool(forKey: "recommendationEngineOnOff")
            cell.switcher.addTarget(self, action: #selector(switcherPressed), for: .valueChanged)
            cell.titleLabel.text = "Recommendation Engine"
        case 1:
            cell.setupVersionStackView()
//            defaults
        default:
            break
        }
        
        return cell
    }
    
    @objc func switcherPressed(_ sender: UISwitch) {
        
        if sender.isOn == true {
            switcherIsOn = true
            defaults.set(switcherIsOn, forKey: "recommendationEngineOnOff")
        } else {
            switcherIsOn = false
            defaults.set(switcherIsOn, forKey: "recommendationEngineOnOff")
        }
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
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

