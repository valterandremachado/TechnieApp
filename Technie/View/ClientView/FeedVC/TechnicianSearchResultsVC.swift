//
//  TechnicianSearchResultsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/8/21.
//

import UIKit

class TechnicianSearchResultsVC: UIViewController {

    var technicianModel = [TechnicianModel]()
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 400
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(TechnicianSearchResultsCell.self, forCellReuseIdentifier: TechnicianSearchResultsCell.cellID)
        return tv
    }()
    
    lazy var warningLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "No results found!"
        return lbl
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        if technicianModel.count == 0 {
            tableView.isHidden = true
            view.addSubview(warningLabel)
            NSLayoutConstraint.activate([
                warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        setupViews()
    }
    
    // MARK: - Methods
    func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        
//        guard let tabHeight = tabBarController?.tabBar.frame.height else { return } // SafeAreaPadding
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        setupNavBar()
    }

    fileprivate func setupNavBar() {
//        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: nil)
//        navBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.title = "Results"
    }
    
    // MARK: - Selectors

}

// MARK: - TableViewDelegateAndDataSource Extension
extension TechnicianSearchResultsVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return technicianModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TechnicianSearchResultsCell.cellID, for: indexPath) as! TechnicianSearchResultsCell
        let model = technicianModel[indexPath.item]
        cell.technicianModel = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TechnicianProfileDetailsVC()
        vc.isSearching = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove bottom extra 20px space.
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return .leastNormalMagnitude
    }
    
//    // UITableViewAutomaticDimension calculates height of label contents/text
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
