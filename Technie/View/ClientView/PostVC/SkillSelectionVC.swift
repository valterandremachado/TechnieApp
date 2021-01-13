//
//  SkillSelectionVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/8/21.
//

import UIKit

// Singleton
protocol SkillSelectionVCDelegate: class {
    func fetchSelectedSkills(skills: [String], didDelete: Bool)
}

class SkillSelectionVC: UIViewController {
    
    weak var skillSelectionVCDelegate: SkillSelectionVCDelegate?
//    static let shared = SkillSelectionVC()
    
    // MARK: - Properties
    var sections = [SectionHandler]()

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
    let userDefaults = UserDefaults.standard

    var selectedSkill = [String]()
    var didDelete = false
    var didAdd = false
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        
//        let defaultArray = userDefaults.set(selectedSkill, forKey: Keys.selectedSkills) // save
//        let selectedSkill = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]() // retrieve
        sections.append(SectionHandler(title: "Selected skills", detail: selectedSkill.first == "" ? ([String]()) : (selectedSkill)))
        sections.append(SectionHandler(title: "Suggested skills", detail: ["skill 1", "skill 2", "skill 3", "skill 4", "skill 5", "skill 6", "skill 7", "skill 8", "skill 9", "skill 10", "skill 11", "skill 12"]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.reloadData()
//        print("viewWillAppear")
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
        
    fileprivate func removeSkill(_ index: Int) {
//        tableView.reloadData()
        didDelete = true
        var sectionOneIndexPath = IndexPath.init(row: 0, section: 0)
        
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                let indexPath = IndexPath(row: j, section: i)
                
                switch indexPath.section {
                case 1:
                    sectionOneIndexPath = indexPath
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SkillsTVCell.cellID, for: sectionOneIndexPath) as? SkillsTVCell else { return }
//                    guard let cell = tableView.cellForRow(at: sectionOneIndexPath) as? SkillsTVCell else { return } // accessing SkillsTVCell outside of its domain
                    let skillFromAddSection = self.sections[1].sectionDetail // list of the items in the selection section
                    let skillFromRemoveSection = self.sections[0].sectionDetail[index] // item to be deleted from the list of the selected section
                    // Check the index of the item to be diselected in the skillFromAddSection
                    let indexOfTappedItem = skillFromAddSection.firstIndex(of: skillFromRemoveSection) ?? 400
                    
                    if arrayOfStringContains(skillFromRemoveSection, section: 1) && sectionOneIndexPath.row == indexOfTappedItem {
                        let modifiedImage = UIImage(systemName: "plus.circle.fill")
                        cell.addSkillBtn.setImage(modifiedImage, for: .normal)
                        self.tableView.reloadRows(at: [sectionOneIndexPath], with: .none) // reloads solely the removed rows
                        print("the same: \(skillFromRemoveSection)")
                        print("row 1: \(sectionOneIndexPath.row)")
                    } else {
                        
//                        print("different: \(skillFromAddSection), \(skillFromRemoveSection), \(indexOfTappedItem), \(sectionOneIndexPath.row)")
                    }
                default:
                    break
                }
                
            }
        }
        
        self.sections[0].sectionDetail.remove(at: index)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        self.tableView.endUpdates()
    }
    
    func updateAddButtonState() {
        print("updateAddButtonState: \(selectedSkill)")
        var sectionOneIndexPath = IndexPath.init(row: 0, section: 0)
        
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                let indexPath = IndexPath(row: j, section: i)
                
                switch indexPath.section {
                case 1:
                    sectionOneIndexPath = indexPath
                    //                    print(sectionOneIndexPath.row)
                    //                    let testIndex = tableView.indexPathForSelectedRow
//                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SkillsTVCell.cellID, for: sectionOneIndexPath) as? SkillsTVCell else { return }
                    guard let cell = tableView.cellForRow(at: sectionOneIndexPath) as? SkillsTVCell else { return } // accessing SkillsTVCell outside of its domain
                    let skillFromAddSection = self.sections[1].sectionDetail // list of the items in the selection section
                    let skillFromRemoveSection = self.sections[0].sectionDetail // item to be deleted from the list of the selected section
                    // Check the index of the item to be diselected in the skillFromAddSection
                    skillFromRemoveSection.forEach { mutualSkill in
                        let indexOfTappedItem = skillFromAddSection.firstIndex(of: mutualSkill) ?? 400
                        
                        if arrayOfStringContains(mutualSkill, section: 1) && sectionOneIndexPath.row == indexOfTappedItem {
                            let modifiedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                            cell.addSkillBtn.setImage(modifiedImage, for: .normal)
                            print("not different")
                        } else {
                            print("different")
                        }
                    }
                default:
                    break
                }
            }
        } // End of loop
        
    }
    
    func arrayOfStringContains(_ item: String, section index: Int)  -> Bool {
        let arrayOfString = self.sections[index].sectionDetail
        return arrayOfString.contains { $0 == item }
    }
    
    fileprivate func addSkill(_ index: Int, _ sender: UIButton) {

        let skillFromAddSection = self.sections[1].sectionDetail[index] // item to be selected from the list of the selection section
        let skillFromRemoveSection = self.sections[0].sectionDetail // list of the items in the selected section
        // Check the index of the item to be diselected in the skillFromAddSection
        let indexOfTappedItem = skillFromRemoveSection.firstIndex(of: skillFromAddSection) ?? 400

        if skillFromRemoveSection.count < 5 {
            if !arrayOfStringContains(skillFromAddSection, section: 0) {
                // Insert items instead of append to give a smooth reload transition
                self.sections[0].sectionDetail.insert(skillFromAddSection, at: 0)
                // Reloads items from the top (beginUpdates & endUpdates are be called because an insertion is happening)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                self.tableView.endUpdates()
                let modifiedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                sender.setImage(modifiedImage, for: .normal)
            } else {
                print("existing Name")
                self.removeSkill(indexOfTappedItem)
                let modifiedImage = UIImage(systemName: "plus.circle.fill")
                sender.setImage(modifiedImage, for: .normal)
            }
        } else {
            // if exists remove it else do nothing
            if arrayOfStringContains(skillFromAddSection, section: 0) {
                print("existing Name2")
                self.removeSkill(indexOfTappedItem)
                let modifiedImage = UIImage(systemName: "plus.circle.fill")
                sender.setImage(modifiedImage, for: .normal)
            } else {
                print("Exceeded")
                presentAlertSheet()
            }
           
        }
        

    }
    
    fileprivate func presentAlertSheet() {
        let alert = UIAlertController(title: "5 Skills Selected", message: "You have selected the maximum required number of skills.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightNavBarBtnTapped() {
//        userDefaults.set(sections[0].sectionDetail, forKey: Keys.selectedSkills)
//        print("saved: \(sections[0].sectionDetail)")
//        NotificationCenter.default.post(name: Notification.Name("UpdateDefaultsArrayNotification"), object: nil, userInfo: nil)

        print("rightNavBarBtnTapped: \(sections[0].sectionDetail)")
        skillSelectionVCDelegate?.fetchSelectedSkills(skills: sections[0].sectionDetail, didDelete: didDelete)
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
            }
        }
        tableView.reloadData()

    }
    
    @objc fileprivate func addSkillBtnTapped(_ sender: UIButton) {
        let cellBtnIndex = sender.tag
        addSkill(cellBtnIndex, sender)
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
            cell.selectionStyle = .none
//            cell.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            //            cell.textLabel?.text = title
            cell.setupViews()
            cell.customLabel.text = title
            cell.removeSkillBtn.tag = indexPath.row
            cell.removeSkillBtn.addTarget(self, action: #selector(removeSkillBtnTapped), for: .touchUpInside)
//            print("added: \(self.sections[0].sectionDetail)")

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillsTVCell.cellID, for: indexPath) as! SkillsTVCell
            cell.selectionStyle = .none
//            cell.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
//            cell.textLabel?.text = title
            cell.setupViews()
            cell.customLabel.text = title
            cell.addSkillBtn.tag = indexPath.row
            cell.addSkillBtn.addTarget(self, action: #selector(addSkillBtnTapped), for: .touchUpInside)
            print("row 2: \(indexPath.row)")
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
