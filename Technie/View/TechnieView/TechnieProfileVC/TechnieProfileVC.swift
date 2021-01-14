//
//  TechnieProfileVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit

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
        view.backgroundColor = .white
        setupViews()
        
        sections.append(SectionHandler(title: "Active Jobs", detail: ["Active 1"]))
        sections.append(SectionHandler(title: "Previous Jobs", detail: ["Active 1", "Active 2"]))
        sections.append(SectionHandler(title: "Previous Jobs2", detail: ["Active 1", "Active 2"]))
        sections.append(SectionHandler(title: "Previous Jobs2", detail: ["Active 1", "Active 2"]))
    }
   
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
                
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
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
            cell.textLabel?.text = "Valter A. Machado"
            cell.detailTextLabel?.text = "Baguio City"
            let newImage = UIImage().resizeImage(image: UIImage(named: "technie")!, toTheSize: CGSize(width: 40, height: 40))
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.cornerRadius = 40 / 2
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.image = newImage
            
//            indexPath.row == lastIndex ? (cell.textLabel?.textColor = .red) : (cell.textLabel?.textColor = .black)
//            indexPath.row == lastIndex ? (cell.accessoryType = .none) : (cell.accessoryType = .disclosureIndicator)
            
        case 1:
            let tableViewOptions = TechnieProfileTVOptions0(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            cell.accessoryType = .disclosureIndicator
            
        case 2:
            let tableViewOptions = TechnieProfileTVOptions1(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            cell.accessoryType = .disclosureIndicator
            
        case 3:
            let tableViewOptions = TechnieProfileTVOptions2(rawValue: indexPath.row)
            cell.textLabel?.text = tableViewOptions?.description
            //        cell.detailTextLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = tableViewOptions?.image
            cell.accessoryType = .disclosureIndicator
            
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
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section > 0 {
//            return sections[section].sectionTitle
//        }
//        return ""
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15))
        headerView.backgroundColor = .white

        let headerLabel = UILabel(frame: CGRect(x: 20, y: -6, width: tableView.frame.width - 15, height: 15))
        headerLabel.textColor = .systemGray
       
        if section > 0 {
            headerLabel.text = ""//sections[section].sectionTitle
//            headerView.isHidden = true
//            headerLabel.text = ""
//            headerView.addBorder(.top, color: .lightGray, thickness: 0.25)
//            headerView.addBorder(.bottom, color: .lightGray, thickness: 0.25)
            headerView.addSubview(headerLabel)
            
            return headerView
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 15
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
