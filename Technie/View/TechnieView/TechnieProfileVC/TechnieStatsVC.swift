//
//  TechnieStatsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/23/21.
//

import UIKit

class TechnieStatsVC: UIViewController {
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
        //        tv.rowHeight = 400
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
        //        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        // Register Custom Cells for each section
        tv.register(TechnieStatsCell.self, forCellReuseIdentifier: TechnieStatsCell.cellID)
        tv.register(ProficiencyReviewCell.self, forCellReuseIdentifier: ProficiencyReviewCell.cellID)
        tv.register(ReviewsCell.self, forCellReuseIdentifier: ReviewsCell.cellID)
//                tv.register(RecommendationCell.self, forCellReuseIdentifier: RecommendationCell.cellID)
        
        return tv
    }()
    
    var sectionSetter = [SectionHandler]()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        view.backgroundColor = .cyan
        setupViews()
        
        sectionSetter.append(SectionHandler(title: "Proficiency", detail: [""]))
        sectionSetter.append(SectionHandler(title: "Reliability", detail: [""]))
        sectionSetter.append(SectionHandler(title: "Reviews", detail: ["Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews"]))
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        //        navBar.clearNavBarAppearance()
        navigationItem.title = "My Stats"
        //        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        
        //        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnieStatsVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSetter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionSetter[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //            let detailText = reviewsSectionSetter[indexPath.section].sectionDetail[indexPath.row]
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TechnieStatsCell.cellID, for: indexPath) as! TechnieStatsCell
            cell.setupViews()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProficiencyReviewCell.cellID, for: indexPath) as! ProficiencyReviewCell
            cell.setupReliabilityStackView()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell.cellID, for: indexPath) as! ReviewsCell
            cell.setupViews()
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return nil
        } else if section == 0 {
            return sectionSetter[section].sectionTitle!
        }
        return sectionSetter[section].sectionTitle! + " (40)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
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
