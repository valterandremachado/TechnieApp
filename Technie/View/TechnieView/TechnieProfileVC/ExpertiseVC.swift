//
//  ExpertiseVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/11/21.
//

import UIKit
import FirebaseDatabase

// Singleton
protocol ExpertiseVCDelegate: class {
    func fetchSelectedSkills(skills: [String])
}

class ExpertiseVC: UIViewController {

    // MARK: - Properties
    weak var expertiseVCDelegate: ExpertiseVCDelegate?

    let database = Database.database().reference()
    
    private var indicator: ProgressIndicatorLarge!
    private var technicianModel: TechnicianModel?
    private var expertise = [String]()

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
//        tv.contentInsetAdjustmentBehavior = .automatic
        
        tv.register(ExpertiseCell.self, forCellReuseIdentifier: ExpertiseCell.cellID)
        tv.register(SuggestedExpertiseCell.self, forCellReuseIdentifier: SuggestedExpertiseCell.cellID)

        return tv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        if isComingFromSignupVC != true {
            getTechnicianInfo()
        } else {
            populateSections()
        }
        setupViews()
    }
    
    var sections = [SectionHandler]()

    // MARK: - Methods
    private func setupViews() {
        [tableView, indicator].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Expertise"
        let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftNavBarBtnTapped))

        if isComingFromSignupVC != true {
            let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightNavBarBtnTapped))
            
            self.navigationItem.leftBarButtonItem = leftNavBarButton
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightNavBarBtnForSignUpVCTapped))
            
            self.navigationItem.leftBarButtonItem = leftNavBarButton
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        }
    }
    
    var isComingFromSignupVC = false
    private func populateSections() {
        if isComingFromSignupVC != true {
            sections.append(SectionHandler(title: "My Expertise", detail: expertise))
            sections.append(SectionHandler(title: "Suggested Expertise", detail: ["Handyman", "Repairer", "Electrician", "Plumber", "Others"]))
        } else {
            sections.append(SectionHandler(title: "My Expertise", detail: []))
            sections.append(SectionHandler(title: "Suggested Expertise", detail: ["Handyman", "Repairer", "Electrician", "Plumber", "Others"]))
        }
    }
    
    private func getTechnicianInfo() {
        indicator.start()

        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid

        DatabaseManager.shared.getSpecificTechnician(technicianKeyPath: technicianKeyPath) { result in
            switch result {
            case .success(let technicianInfo):
                self.expertise = technicianInfo.profileInfo.skills
                self.technicianModel = technicianInfo
                self.populateSections()
                
                self.indicator.stop()
                self.tableView.reloadData()
                self.updateAddButtonState()

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func updateAddButtonState() {
        var sectionOneIndexPath = IndexPath.init(row: 0, section: 0)
        
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                let indexPath = IndexPath(row: j, section: i)
                
                switch indexPath.section {
                case 1:
                    sectionOneIndexPath = indexPath

                    guard let cell = tableView.cellForRow(at: sectionOneIndexPath) as? SuggestedExpertiseCell else { return } // accessing SkillsTVCell outside of its domain

                    let skillFromAddSection = self.sections[1].sectionDetail // list of the items in the selection section
                    let skillFromRemoveSection = self.sections[0].sectionDetail // item to be deleted from the list of the selected section
                    // Check the index of the item to be diselected in the skillFromAddSection
                    skillFromRemoveSection.forEach { mutualSkill in
                        let indexOfTappedItem = skillFromAddSection.firstIndex(of: mutualSkill) ?? 400
                        
                        if arrayOfStringContains(mutualSkill, section: 1) && sectionOneIndexPath.row == indexOfTappedItem {
                            let modifiedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                            cell.addSkillBtn.setImage(modifiedImage, for: .normal)
                        } else {
                        }
                    }
                default:
                    break
                }
            }
        } // End of loop
        
    }
    
    fileprivate func removeSkill(_ index: Int) {
        
        var sectionOneIndexPath = IndexPath.init(row: 0, section: 0)
        
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                let indexPath = IndexPath(row: j, section: i)
                
                switch indexPath.section {
                case 1:
                    sectionOneIndexPath = indexPath
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedExpertiseCell.cellID, for: sectionOneIndexPath) as? SuggestedExpertiseCell else { return }

                    let skillFromAddSection = self.sections[1].sectionDetail // list of the items in the selection section
                    let skillFromRemoveSection = self.sections[0].sectionDetail[index] // item to be deleted from the list of the selected section
                    // Check the index of the item to be diselected in the skillFromAddSection
                    let indexOfTappedItem = skillFromAddSection.firstIndex(of: skillFromRemoveSection) ?? 400
//                    print("indexOfTappedItem: ", indexOfTappedItem, ", sectionOneIndexPath: ", sectionOneIndexPath, ", index: ",index)
                    if arrayOfStringContains(skillFromRemoveSection, section: 1) && sectionOneIndexPath.row == indexOfTappedItem {
//                        print("same: \(skillFromRemoveSection)")
                        let modifiedImage = UIImage(systemName: "plus.circle.fill")
                        cell.addSkillBtn.setImage(modifiedImage, for: .normal)
                        self.tableView.reloadRows(at: [sectionOneIndexPath], with: .none) // reloads solely the removed rows
                    } else {
//                        print("different")//: \(skillFromAddSection), \(skillFromRemoveSection), \(indexOfTappedItem), \(sectionOneIndexPath.row)")
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
    
    fileprivate func addSkill(_ index: Int, _ sender: UIButton) {
        
        let skillFromAddSection = self.sections[1].sectionDetail[index] // item to be selected from the list of the selection section
        let skillFromRemoveSection = self.sections[0].sectionDetail // list of the items in the selected section
        // Check the index of the item to be diselected in the skillFromAddSection
        let indexOfTappedItem = skillFromRemoveSection.firstIndex(of: skillFromAddSection) ?? 400
        
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
        
    }
    
    func arrayOfStringContains(_ item: String, section index: Int)  -> Bool {
        let arrayOfString = self.sections[index].sectionDetail
        return arrayOfString.contains { $0 == item }
    }
    
    func presentAlertControllerForOthersSkill() {
        var locationField = UITextField()
        locationField.placeholder = "Expertise (ex: Plumber)"

        let alertController = UIAlertController(title: "Other Expertise", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let expertiseInput = alertController.textFields?[0].text else { return }
            
            self.sections[0].sectionDetail.insert(expertiseInput, at: 0)
            // Reloads items from the top (beginUpdates & endUpdates are be called because an insertion is happening)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self.tableView.endUpdates()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.placeholder = "Expertise (ex: Plumber)"
            locationField = addTextField
        }
        
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightNavBarBtnTapped() {
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let updatedSkills = self.sections[0].sectionDetail
        let technicianKeyPath = getUsersPersistedInfo.uid
        
        let updateElement = [
            "skills": updatedSkills
        ] as [String : Any]
        
        
        let childPath = "users/technicians/\(technicianKeyPath)/profileInfo"
        database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            guard error == nil else {
                return
            }
        })
        
        print(self.sections[0].sectionDetail)
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightNavBarBtnForSignUpVCTapped() {
        let selectedSkills = self.sections[0].sectionDetail
        if selectedSkills.isEmpty {
            let alert = UIAlertController(title: "Oops!", message: "You have not selected any expertise.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        } else {
            expertiseVCDelegate?.fetchSelectedSkills(skills: selectedSkills)
            dismiss(animated: true, completion: nil)
        }
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
    
    @objc func addOthersSkillBtnTapped() {
        presentAlertControllerForOthersSkill()
    }
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension ExpertiseVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionsDetails = sections[indexPath.section].sectionDetail[indexPath.row]
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpertiseCell.cellID, for: indexPath) as! ExpertiseCell

            cell.selectionStyle = .none
            cell.setupMyExpertiseViews()
            cell.customLabel.text = sectionsDetails
            cell.removeSkillBtn.tag = indexPath.row
            cell.removeSkillBtn.addTarget(self, action: #selector(removeSkillBtnTapped), for: .touchUpInside)
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedExpertiseCell.cellID, for: indexPath) as! SuggestedExpertiseCell

            cell.selectionStyle = .none
            cell.setupSuggestedExpertiseViews()
            cell.customLabel.text = sectionsDetails
            cell.addSkillBtn.tag = indexPath.row
            
            if indexPath.row != 4 {
                cell.addSkillBtn.addTarget(self, action: #selector(addSkillBtnTapped), for: .touchUpInside)
            } else {
                cell.addSkillBtn.addTarget(self, action: #selector(addOthersSkillBtnTapped), for: .touchUpInside)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
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
