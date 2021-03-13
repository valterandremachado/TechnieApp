//
//  FullRankingVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/19/20.
//

import UIKit

class FullRankingVC: UIViewController {

    var technieRank: [TechnicianModel] = []
    var userPostModel: [PostModel] = []
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
//    var sectionSetter = [SectionHandler]()
    
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
    
    var sectionSetter = ["Top 5", "Remaining Rank"]
    var topFiveRank: [TechnicianModel] = []
    var remainingRank: [TechnicianModel] = []
    let topFiveLimit = 1
    
    fileprivate func populateSection() {
        topFiveRank = Array<TechnicianModel>(technieRank.prefix(5))
        if technieRank.count == 5 {
            remainingRank = Array<TechnicianModel>(technieRank.suffix(from: 6))
        }
        print("count: ", technieRank.count)
    }
    
    
    let proficiencyInDecimal: [Double] = [0.25, 0.50, 0.75, 1.0]
    var workSpeed = 0
    var workQuality = 0
    var responseTime = 0
    
    // MARK: - Selectors

}

// MARK: - CollectionDataSourceAndDelegate Extension
extension FullRankingVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionSetter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
//            let topFiveRank = Array<TechnicianModel>(technieRank.prefix(topFiveLimit))
            return topFiveRank.count
        } else {
            return remainingRank.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: FullRankingCell.cellID, for: indexPath) as! FullRankingCell
        cell = FullRankingCell(style: .subtitle, reuseIdentifier: FullRankingCell.cellID)
        
//        let detailForRow = sectionSetter[indexPath.section].sectionDetail[indexPath.row]
        switch indexPath.section {
        case 0:
            let topFiveRankModel = topFiveRank[indexPath.row]

            cell.detailTextLabel?.textColor = .systemGray
            cell.textLabel?.text = "#\(indexPath.row + 1) " + topFiveRankModel.profileInfo.name//indexPath.section == 0 ? () : ("#\(indexPath.row + 6) " + detailForRow)
            
            workSpeed = Int(topFiveRankModel.clientsSatisfaction?.workSpeedAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            workQuality = Int(topFiveRankModel.clientsSatisfaction?.workQualityAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            responseTime = Int(topFiveRankModel.clientsSatisfaction?.responseTimeAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            
            let sum = proficiencyInDecimal[workSpeed] + proficiencyInDecimal[workQuality] + proficiencyInDecimal[responseTime]
            let proficiencyInPercentage = "\(String(format:"%.0f", sum/3 * 100))%"
            
            let services = topFiveRankModel.numberOfServices
            var serviceLabel = ""
            services <= 1 ? (serviceLabel = "service") : (serviceLabel = "services")
            cell.detailTextLabel?.text = "\(services) \(serviceLabel) | proficiency (\(proficiencyInPercentage))"
        case 1:
            let remainingRankModel = remainingRank[indexPath.row]

            cell.detailTextLabel?.textColor = .systemGray
            cell.textLabel?.text = "#\(technieRank.count + indexPath.row + 1) " + remainingRankModel.profileInfo.name//indexPath.section == 0 ? ("#\(indexPath.row + 1) " + detailForRow) : ("#\(indexPath.row + 6) " + detailForRow)
            
            workSpeed = Int(remainingRankModel.clientsSatisfaction?.workSpeedAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            workQuality = Int(remainingRankModel.clientsSatisfaction?.workQualityAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            responseTime = Int(remainingRankModel.clientsSatisfaction?.responseTimeAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            
            let sum = proficiencyInDecimal[workSpeed] + proficiencyInDecimal[workQuality] + proficiencyInDecimal[responseTime]
            let proficiencyInPercentage = "\(String(format:"%.0f", sum/3 * 100))%"
            
            let services = remainingRankModel.numberOfServices
            var serviceLabel = ""
            services <= 1 ? (serviceLabel = "service") : (serviceLabel = "services")
            cell.detailTextLabel?.text = "\(services) \(serviceLabel) | proficiency (\(proficiencyInPercentage))"
        default:
            break
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = TechnicianProfileDetailsVC()
        
        switch indexPath.section {
        case 0:
            let technicians = topFiveRank[indexPath.item]

            vc.technicianModel = technicians
            vc.userPostModel = userPostModel
            vc.profileImageView.sd_setImage(with: URL(string: technicians.profileInfo.profileImage ?? ""))
            vc.nameLabel.text = technicians.profileInfo.name
            vc.locationLabel.text = "\(technicians.profileInfo.location), Philippines"
            vc.technicianExperienceLabel.text = "• \(technicians.profileInfo.experience) Year of Exp."
            
            let delimiter = "at"
            let slicedString = technicians.profileInfo.membershipDate.components(separatedBy: delimiter)[0]
            vc.memberShipDateLabel.text = "• Member since " + slicedString
            
            navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            let technicians = remainingRank[indexPath.item]

            vc.technicianModel = technicians
            vc.userPostModel = userPostModel
            vc.profileImageView.sd_setImage(with: URL(string: technicians.profileInfo.profileImage ?? ""))
            vc.nameLabel.text = technicians.profileInfo.name
            vc.locationLabel.text = "\(technicians.profileInfo.location), Philippines"
            vc.technicianExperienceLabel.text = "• \(technicians.profileInfo.experience) Year of Exp."
            
            let delimiter = "at"
            let slicedString = technicians.profileInfo.membershipDate.components(separatedBy: delimiter)[0]
            vc.memberShipDateLabel.text = "• Member since " + slicedString
            
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
       
    }
    
    // Header layout
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return topFiveRank.count == 0 ? (nil) : (sectionSetter[0])
        } else {
            return remainingRank.count == 0 ? (nil) : (sectionSetter[1])
        }
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
