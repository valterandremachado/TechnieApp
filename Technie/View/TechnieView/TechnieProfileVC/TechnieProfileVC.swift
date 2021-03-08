//
//  TechnieProfileVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit
import FirebaseAuth

class TechnieProfileVC: UIViewController {
        
    let stringArray = ["Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala"]
    let detailArray = ["LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala"]
    let imageArray = ["person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill"]
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .white
        tv.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        tv.tableFooterView = UIView()
        
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
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(TechineProfileTVCell.self, forCellReuseIdentifier: TechineProfileTVCell.cellID)
        return tv
    }()
    
    var sections = [SectionHandler]()

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchSavedJobs(notification:)), name: NSNotification.Name("SavedJobsNotificationObserver"), object: nil)

        setupViews()
        
        sections.append(SectionHandler(title: "UserInfo", detail: [""]))
        sections.append(SectionHandler(title: "AccountInfo", detail: ["", "", ""]))
        sections.append(SectionHandler(title: "Share and Help", detail: ["", "", ""]))
        sections.append(SectionHandler(title: "Logout", detail: [""]))
    }
   
    @objc func fetchSavedJobs(notification: NSNotification) {
        print("Value of notification : ", notification.object ?? "")
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
                
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Settings"
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    // MARK: - Selectors
    
    
}


// MARK: - TableViewDelegateAndDataSource Extension
extension TechnieProfileVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count //stringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TechineProfileTVCell.cellID, for: indexPath) as! TechineProfileTVCell
        // Enables detailTextLabel visibility
        cell = TechineProfileTVCell(style: .subtitle, reuseIdentifier: TechineProfileTVCell.cellID)
        
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        let lastIndex = lastRowIndex - 1
        
        // Customize Cell
        //        cell.textLabel?.textColor = .black
        //        cell.detailTextLabel?.textColor = .black
        //        cell.backgroundColor = .white
        
//        let tableViewOptions = TechnieProfileTVOptions(rawValue: indexPath.row)
        switch indexPath.section {
        case 0:
//            let userName = UserDefaults.standard.value(forKey: "email") as? String ?? ""
            let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
            
            var userPersistedEmail = ""
            if let info = getUsersPersistedInfo {
                userPersistedEmail = info.first!.email
            }
            
            cell.textLabel?.text = userPersistedEmail //"Valter A. Machado"
            cell.detailTextLabel?.text = "Baguio City"
            let newImage = UIImage().resizeImage(image: UIImage(named: "technie")!, toTheSize: CGSize(width: 40, height: 40))
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.cornerRadius = 40 / 2
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.image = newImage
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
            
        case 1:
            let tableViewOptions = TechnieProfileTVOptions0(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)

        case 2:
            let tableViewOptions = TechnieProfileTVOptions1(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)

        case 3:
            let tableViewOptions = TechnieProfileTVOptions2(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            indexPath.row == lastIndex ? (cell.accessoryType = .none) : (cell.accessoryType = .disclosureIndicator)
            indexPath.row == lastIndex ? (cell.textLabel?.textColor = .red) : (cell.textLabel?.textColor = .black)
            cell.backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)

        default:
            break
        }
        // Pass data
//        cell.textLabel?.text = tableViewOptions?.description
//        //        cell.detailTextLabel?.text = detailArray[indexPath.row]
//        cell.imageView?.image = tableViewOptions?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let vc = TechnieEditProfileVC()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            if indexPath.row == 0 {
                let vc = TechnieAccountVC()
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                let vc = TechnieSavedJobsVC()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = TechnieStatsVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if indexPath.row == 0 {
                let vc = TechnieGeneralVC()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ClientTabController()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }
         
        case 3:
            if indexPath.row == 0 {
                try! Auth.auth().signOut()
                print("Logged Out")
            }
        
        default:
            break
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section > 0 {
//            return sections[section].sectionTitle
//        }
//        return ""
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .white

        let headerLabel = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.width, height: 30))
        headerLabel.textColor = .systemGray
       
        if section > 0 {
            headerLabel.text = ""//sections[section].sectionTitle
            headerView.addSubview(headerLabel)
            
            return headerView
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
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

// MARK: - TechnieProfileVCPreviews
import SwiftUI

struct TechnieProfileVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = TechnieProfileVC()
        return vc.liveViewController
    }
    
}
