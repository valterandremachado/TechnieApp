//
//  SkillSelectionVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/8/21.
//

import UIKit

class SkillSelectionVC: UIViewController {
    
    // MARK: - Properties
    fileprivate var sections = [SectionHandler]()

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        sb.placeholder = "Search for skills"
        sb.tintColor = .systemPink
//        sb.backgroundColor = .red
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.delegate = self
        return sb
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = 40
        tv.delegate = self
        tv.dataSource = self
        tv.register(SelectedTVCell.self, forCellReuseIdentifier: SelectedTVCell.cellID)
        tv.register(SkillsTVCell.self, forCellReuseIdentifier: SkillsTVCell.cellID)
        return tv
    }()
    
    var customArray = [String]()
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        
        sections.append(SectionHandler(title: "Selected skills", detail: ["skill 0", "skill 1", "skill 2"]))
        sections.append(SectionHandler(title: "Suggested skills", detail: ["skill 3", "skill 4", "skill 5", "skill 6"]))
//        customArray.append(contentsOf: sections[0].sectionDetail)
    }
    

    // MARK: - Methods
    fileprivate func setupViews() {
        setupNavBar()
        [searchBar, tableView].forEach { view.addSubview($0)}
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5), size: CGSize(width: 0, height: 44))
        
        tableView.anchor(top: searchBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Add Skills"
//        navBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
        let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftNavBarBtnTapped))
        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightNavBarBtnTapped))

        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = rightNavBarButton
//        navigationItem.searchController = searchController
    }
    
    var customInt = ""
    
    fileprivate func removeSkill(_ index: Int) {
//        customInt = self.sections[0].sectionDetail[index]
        self.sections[0].sectionDetail.remove(at: index)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        self.tableView.endUpdates()
    }
    
//    func restoreAddSkillBtnImage(_ sender: UIButton) {
////        tableView.reloadData()
//        let newSkill = self.sections[1].sectionDetail //[customInt]
//        let selectedSkill = self.sections[0].sectionDetail
//        if customInt == newSkill.first {
//            print("remove area: \(customInt)")
//            print("add area: \(newSkill)")
//            let modifiedImage = UIImage(systemName: "plus.circle.fill")
//            sender.setImage(modifiedImage, for: .normal)
//        } else {
////            print("else")
//            print("ELSE remove area: \(customInt)")
//            print("ELSE add area: \(newSkill.first)")
//        }
//
//
//    }
    func isValid(_ item: String)  -> Bool {

        let whitelist = self.sections[0].sectionDetail

        return whitelist.contains { $0 == item }
    }
    
    fileprivate func addSkill(_ index: Int, _ sender: UIButton) {

        let newSkill = self.sections[1].sectionDetail[index]
        let selectedSkill = self.sections[0].sectionDetail
        
        if selectedSkill.count < 5 {
            if !isValid(newSkill) {
                // Insert items instead of append to give a smooth reload transition
                self.sections[0].sectionDetail.insert(newSkill, at: 0)
                // Reloads items from the top (beginUpdates & endUpdates are be called because an insertion is happening)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                self.tableView.endUpdates()
                let modifiedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                sender.setImage(modifiedImage, for: .normal)
            } else {
                print("existing Name")
                // refresh the cell with the latest array index in order to pass the correct index to the cellBtnIndex variable
                tableView.reloadData()
                // 1 milisec queue in order to avoid distortion on the deletion animation
                DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(1)) {
//                     UI components must be in the main Grand Center Dispatch (GCD)
                    DispatchQueue.main.async {
                        let cellBtnIndex2 = sender.tag
                        self.removeSkill(cellBtnIndex2)
                        let modifiedImage = UIImage(systemName: "plus.circle.fill")
                        sender.setImage(modifiedImage, for: .normal)
                    }
                }
            }
        } else {
            print("Exceeded")
            if newSkill == selectedSkill.first {
            tableView.reloadData()
            // 1 milisec queue in order to avoid distortion on the deletion animation
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(1)) {
                // UI components must be in the main Grand Center Dispatch (GCD)
                DispatchQueue.main.async {
                    let cellBtnIndex2 = sender.tag
                    self.removeSkill(cellBtnIndex2)
                    let modifiedImage = UIImage(systemName: "plus.circle.fill")
                    sender.setImage(modifiedImage, for: .normal)
                }
            }
            }
        }

    }
    
    // MARK: - Selectors
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func removeSkillBtnTapped(_ sender: UIButton) {
        // refresh the cell with the latest array index in order to pass the correct index to the cellBtnIndex variable
        tableView.reloadData()
        // 1 milisec queue in order to avoid distortion on the deletion animation
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(1)) {
            // UI components must be in the main Grand Center Dispatch (GCD)
            DispatchQueue.main.async { [self] in
                let cellBtnIndex = sender.tag
                self.removeSkill(cellBtnIndex)
               
//                for i in 0..<tableView.numberOfSections {
//                    for j in 0..<tableView.numberOfRows(inSection: i) {
//                        let indexPath = IndexPath(row: j, section: i)
//                        if indexPath.section == 1 && indexPath.row == cellBtnIndex {
//                            let modifiedImage = UIImage(systemName: "plus.circle.fill")
//                            sender.setImage(modifiedImage, for: .normal)
//                        }
//                    }
//                }
                
            }
        }

    }
    
    @objc fileprivate func addSkillBtnTapped(_ sender: UIButton) {
        
        let cellBtnIndex = sender.tag
        
//        let newSkill = self.sections[1].sectionDetail[cellBtnIndex]
//        let selectedSkill = self.sections[0].sectionDetail
        
//        if selectedSkill.count < 5 {
//            /// checks if the skill tapped is already part of the array of skill (if it's not, add to it then change the btn image to a minus.circle.fill image. If it's already in the array remove it from the array then change the btn image to a plus.circle.fill image  )
//            if newSkill == selectedSkill.first {
//                // refresh the cell with the latest array index in order to pass the correct index to the cellBtnIndex variable
//                tableView.reloadData()
//                // 1 milisec queue in order to avoid distortion on the deletion animation
//                DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(1)) {
//                    // UI components must be in the main Grand Center Dispatch (GCD)
//                    DispatchQueue.main.async {
//                        let cellBtnIndex2 = sender.tag
//                        self.removeSkill(cellBtnIndex2)
//                        let modifiedImage = UIImage(systemName: "plus.circle.fill")
//                        sender.setImage(modifiedImage, for: .normal)
//                    }
//                }
//            } else {
                addSkill(cellBtnIndex, sender)
//                let modifiedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
//                sender.setImage(modifiedImage, for: .normal)
//            }
//        } else {
//            print("greater")
//        }
       
    }
    
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension SkillSelectionVC: TableViewDataSourceAndDelegate {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTVCell.cellID, for: indexPath) as! SelectedTVCell
//            cell.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            //            cell.textLabel?.text = title
            cell.setupViews()
            cell.customLabel.text = title
            cell.removeSkillBtn.tag = indexPath.row
            cell.removeSkillBtn.addTarget(self, action: #selector(removeSkillBtnTapped), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillsTVCell.cellID, for: indexPath) as! SkillsTVCell
//            cell.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
//            cell.textLabel?.text = title
            cell.setupViews()
            cell.customLabel.text = title
            cell.addSkillBtn.tag = indexPath.row
            cell.addSkillBtn.addTarget(self, action: #selector(addSkillBtnTapped), for: .touchUpInside)
//            restoreAddSkillBtnImage(cell.addSkillBtn)
//            if sections[0].sectionDetail != sections[1].sectionDetail {
//                let modifiedImage = UIImage(systemName: "plus.circle.fill")
//                cell.addSkillBtn.setImage(modifiedImage, for: .normal)
//            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
   
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section].sectionTitle
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .white
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: -6, width: tableView.frame.width - 15, height: 40))
        headerLabel.textColor = .systemGray
        headerLabel.text = sections[section].sectionTitle
        headerView.addSubview(headerLabel)
        return headerView
    }
    
}

// MARK: - UISearchBarDelegate Extension
extension SkillSelectionVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("1")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("2")
    }
    
//    func presentSearchController(_ searchController: UISearchController) {
//        searchController.searchBar.becomeFirstResponder()
//    }
}
