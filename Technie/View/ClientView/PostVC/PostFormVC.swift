//
//  PostFormVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/29/20.
//

import UIKit

struct SectionTitle {
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
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()

//        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = 40
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
    
    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
//        lbl.backgroundColor = .cyan
        lbl.textAlignment = .right
        lbl.text = "PHP"
        return lbl
    }()
    
    lazy var budgetPickerBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = UIColor(displayP3Red: 235/255, green: 51/255, blue: 72/255, alpha: 0.2)
//        btn.backgroundColor = .brown
        btn.setTitle("₱200 - ₱800 / hour", for: .normal)
//        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
//        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .left
//        btn.isHidden = true
//        btn.withWidth(80)
        //        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [budgetPickerBtn, customLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillEqually
//        sv.addBackground(color: .lightGray)
        
        return sv
    }()
    
    var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .black
        
//        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
//        let spaceBetweenItems = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onDoneButtonTapped))
//        toolBar.items = [cancelBtn, spaceBetweenItems, doneBtn]
        return toolBar
    }()
    
    lazy var budgetPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        return picker
    }()
    
    lazy var pickerCustomView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        
        cv.addSubview(budgetPicker)
//        picker.backgroundColor = .brown
        budgetPicker.anchor(top: nil, leading: cv.leadingAnchor, bottom: cv.bottomAnchor, trailing: cv.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 105))

        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnTapped))
        let spaceBetweenItems = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTapped))
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: 0, width: UIScreen.main.bounds.size.width, height: 35))
        toolBar.items = [cancelBtn, spaceBetweenItems, doneBtn]
        cv.addSubview(toolBar)
        cv.fadeOut()
        return cv
    }()
    
    var isPicking = false
    
    var customArray: [String] = ["₱200 - ₱300 / hour", "₱300 - ₱400 / hour", "₱400 - ₱500 / hour"]
    let handymanSectionArray = ["Plumbing Installation/Leaking Plumbing", "Drywall Installation", "Fixture Replacement", "Painting for the Interior and Exterior", "Power Washing", "Tile Installation", "Deck/Door/Window Repair", "Carpenter", "Cabinetmaker", "Others"]

    var finalPick = ""
    var pickerIndex = 0
    let userDefaults = UserDefaults.standard
//    lazy var pickerStoredIndex = userDefaults.integer(forKey: Keys.pickerStoredIndex)

    struct Keys {
        static let pickerStoredIndex = "pickerIndex"
    }

    var skillArray = [""]
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
        setupViews()

        sections.append(SectionTitle.init(title: "Project Title & Description", description: ["0", "1", ""]))
        sections.append(SectionTitle.init(title: "Project Type", description: ["0"]))
        sections.append(SectionTitle.init(title: "Project Budget", description: ["0"]))
        sections.append(SectionTitle.init(title: "Skills Required", description: skillArray))

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset userDefaults
        userDefaults.removeObject(forKey: Keys.pickerStoredIndex)
    }

    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func addSkillData(_ skillTitle: String?) {
        guard let skill = skillTitle else { return }
        let existingSkill = self.sections[3].description.first
        
        if skill != existingSkill && skill != "" {
        // Insert items instead of append to give a smooth relead transition
            self.skillArray.insert(skill, at: 0)
            self.sections[3].description = self.skillArray
            // Reloads items from the top
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
            self.tableView.endUpdates()
        } else {
            print("existing Name")
        }
    }
    
    fileprivate func presentActionSheet() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Schedule", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.addSkillData(textField.text)
        }
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Creat new item"
            textField = addTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc func addSkillsBtnTapped() {
        presentActionSheet()
    }
    
    

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
            // PostFormCell
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! PostFormCell
            cell.backgroundColor = .white
            
            cell.textLabel?.text = title
            
            switch indexPath.row {
            case 0:
                let projectTitleTextField = UITextField()
                projectTitleTextField.placeholder = "Title"
                projectTitleTextField.backgroundColor = .white
                
                cell.addSubview(projectTitleTextField)
                //                cell.sendSubviewToBack(viewC)
                projectTitleTextField.anchor(top: cell.topAnchor, leading: cell.textLabel?.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.textLabel?.trailingAnchor)
            case 1:
                let projectDescriptionTextField = UITextField()
                projectDescriptionTextField.placeholder = "Description"
                projectDescriptionTextField.backgroundColor = .white
                                
                cell.addSubview(projectDescriptionTextField)
                //                cell.sendSubviewToBack(viewC)
                projectDescriptionTextField.anchor(top: cell.topAnchor, leading: cell.textLabel?.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.textLabel?.trailingAnchor)
            case 2:
                cell.setupViews()
            default:
                break
            }
            
            return cell
        case 1:
            // PostFormProjectTypeCell
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormProjectTypeCell.cellID, for: indexPath) as! PostFormProjectTypeCell
            cell.setupViews()
            return cell
        case 2:
            // PostFormBudgetCell
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormBudgetCell.cellID, for: indexPath) as! PostFormBudgetCell
            [stackView].forEach {cell.contentView.addSubview($0)}
            stackView.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.safeAreaLayoutGuide.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: cell.separatorInset.left + 5, bottom: 0, right: cell.separatorInset.right + 15))
//            cell.setupViews()
            budgetPickerBtn.addTarget(self, action: #selector(budgetPickerBtnTapped), for: .touchUpInside)
            return cell
        case 3:
            // PostFormSkillCell
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormSkillCell.cellID, for: indexPath) as! PostFormSkillCell
            
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            let lastIndex = lastRowIndex - 1

            if indexPath.row == lastIndex {
                cell.setupViews()
                cell.addSkillsBtn.addTarget(self, action: #selector(addSkillsBtnTapped), for: .touchUpInside)
            } else {
                cell.textLabel?.text = title
                cell.addSkillsBtn.isHidden = true
            }
            
            return cell
        default:
            break
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
        return sections[section].title
        }
        return ""
    }

    
}

// MARK: - UIPickerViewDelegate Extension
extension PostFormVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customArray.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        print("\(customArray[row])")
        return customArray[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Store row index in order to use it outside of its method
        pickerIndex = row
        print("didselect: "+customArray[row])
        finalPick = customArray[row]
    }
    
    fileprivate func setupPickerView() {
        self.view.addSubview(pickerCustomView)
        NSLayoutConstraint.activate([
            pickerCustomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pickerCustomView.heightAnchor.constraint(equalToConstant: 140),
            pickerCustomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerCustomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        pickerCustomView.fadeIn()
    }
    
    @objc func budgetPickerBtnTapped(_ sender: UIButton) {
        setupPickerView()
    }
    
    @objc func doneBtnTapped() {
        pickerCustomView.removeFromSuperview()
        print("123: "+finalPick)
        userDefaults.set(pickerIndex, forKey: Keys.pickerStoredIndex)
        let pickerStoredIndex = userDefaults.integer(forKey: Keys.pickerStoredIndex)

        if finalPick != "" {
        budgetPicker.selectRow(pickerStoredIndex, inComponent: 0, animated: true)
        budgetPickerBtn.setTitle(finalPick, for: .normal)
        }
        pickerCustomView.fadeOut()
    }
    
    @objc func cancelBtnTapped() {
        pickerCustomView.fadeOut()
        pickerCustomView.removeFromSuperview()
        let pickerStoredIndex = userDefaults.integer(forKey: Keys.pickerStoredIndex)
        budgetPicker.selectRow(pickerStoredIndex, inComponent: 0, animated: true)
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
