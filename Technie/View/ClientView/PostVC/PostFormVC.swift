//
//  PostFormVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/29/20.
//

import UIKit

class SectionTitle {
    var title: String?
    var description: [String]
    
    init(title: String, description: [String]) {
        self.title = title
        self.description = description
    }
}

class PostFormVC: UIViewController {
    private let tableCellID = "cellID"
    var sections = [SectionTitle]()
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()

//        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
//        tv.layer.cornerRadius = 18
//        tv.clipsToBounds = true

        tv.delegate = self
        tv.dataSource = self
        tv.register(PostFormCell.self, forCellReuseIdentifier: tableCellID)
        tv.register(PostFormProjectTypeCell.self, forCellReuseIdentifier: PostFormProjectTypeCell.cellID)
        tv.register(PostFormBudgetCell.self, forCellReuseIdentifier: PostFormBudgetCell.cellID)
        tv.register(PostFormSkillCell.self, forCellReuseIdentifier: PostFormSkillCell.cellID)


        return tv
    }()
    
    let handymanSectionArray = ["Plumbing Installation/Leaking Plumbing", "Drywall Installation", "Fixture Replacement", "Painting for the Interior and Exterior", "Power Washing", "Tile Installation", "Deck/Door/Window Repair", "Carpenter", "Cabinetmaker", "Others"]

    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        setupViews()
        
        sections.append(SectionTitle.init(title: "Project Title & Description", description: ["description", "description"]))
        sections.append(SectionTitle.init(title: "Project Type", description: ["description", "description"]))
        sections.append(SectionTitle.init(title: "Project Budget", description: ["description", "description"]))
        sections.append(SectionTitle.init(title: "Skills Required", description: ["description", "description"]))

    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    // MARK: - Selectors


}

extension PostFormVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].description.count//handymanSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles =  sections[indexPath.section]
        let title = titles.description[indexPath.row]
        
        //        if indexPath.section == 0 && indexPath.row == 0 {
        ////            tableView.rowHeight = 90
        //            let viewC = UIView()
        ////            viewC.translatesAutoresizingMaskIntoConstraints = false
        ////            viewC.backgroundColor = .brown
        //            cell.addSubview(viewC)
        //            viewC.anchor(top: cell.topAnchor, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor)
        //        }
        //        cell.textLabel?.text = title //handymanSectionArray[indexPath.row]
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! PostFormCell
            cell.textLabel?.text = title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormProjectTypeCell.cellID, for: indexPath) as! PostFormProjectTypeCell
//            cell.withHeight(100)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormBudgetCell.cellID, for: indexPath) as! PostFormBudgetCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormSkillCell.cellID, for: indexPath) as! PostFormSkillCell
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section > 0 {
        return sections[section].title
//        }
//        return ""
    }

    
}



// MARK: - PostFormPreviews
import SwiftUI

struct PostFormPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = PostFormVC()
        return vc.liveViewController
    }
    
}
