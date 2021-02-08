//
//  FullRankingVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/19/20.
//

import UIKit

class FullRankingVC: UIViewController {

    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        
//        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.clipsToBounds = true
//        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(FullRankingCell.self, forCellReuseIdentifier: FullRankingCell.cellID)
        return tv
    }()
    
    let rankArray = ["Valter A. Machado1", "Valter A. Machado2", "Valter A. Machado3", "Valter A. Machado4", "Valter A. Machado5", "Valter A. Machado", "Valter A. Machado", "Valter A. Machado", "Valter A. Machado"]
    var sectionSetter = [SectionHandler]()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
        populateSection()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right:  0))
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationItem.title = "Technie Rank"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func populateSection() {
        // Filtering the rank to have a different section for top 5 ranking from the rest
        let topFiveRank = Array<String>(rankArray.prefix(5))
        let remainingRank = rankArray.filter { topFiveRank.contains($0) == false }

        sectionSetter.append(SectionHandler(title: "Top 5", detail: topFiveRank))
        sectionSetter.append(SectionHandler(title: "Remaining Rank", detail: remainingRank))
    }
    
    // MARK: - Selectors

}

// MARK: - CollectionDataSourceAndDelegate Extension
extension FullRankingVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionSetter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionSetter[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: FullRankingCell.cellID, for: indexPath) as! FullRankingCell
        cell = FullRankingCell(style: .subtitle, reuseIdentifier: FullRankingCell.cellID)
        
        let detailForRow = sectionSetter[indexPath.section].sectionDetail[indexPath.row]
        
        cell.detailTextLabel?.textColor = .systemGray
        cell.textLabel?.text = indexPath.section == 0 ? ("#\(indexPath.row + 1) " + detailForRow) : ("#\(indexPath.row + 6) " + detailForRow)
        cell.detailTextLabel?.text = "300 services | reviews (40)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TechnicianProfileDetailsVC()
//        vc.devidingNo = 2.5
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Header layout
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionSetter[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove bottom extra 20px space.
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return .leastNormalMagnitude
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section <= 1 {
            return 35
        }
        return .leastNormalMagnitude
    }

    
   
}
