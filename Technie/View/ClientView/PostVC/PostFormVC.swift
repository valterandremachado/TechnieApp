//
//  PostFormVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/29/20.
//

import UIKit


struct Keys {
    static let pickerStoredIndex = "pickerIndex"
    static let selectedSkills = "selectedSkillsUserDefaults"
}

class PostFormVC: UIViewController {
    private let tableCellID = "cellID"
    var sections = [SectionHandler]()
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView()
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
        // Register Custom Cells for each section
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
    
    var imageDataArray = [Data]()
    var imageNameArray = [String]()
    lazy var attachedFileArray = ["imageData" : imageDataArray, "imageName": imageNameArray] as [String : Any]
    
    var initialSelectedSkill = [""]
    
    let singleton = SkillSelectionVC()//.shared
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
//        singleton.delegate = self
        setupViews()

        sections.append(SectionHandler(title: "Project Title & Description", detail: ["0", "1", ""]))
        sections.append(SectionHandler(title: "Project Type", detail: ["0"]))
        sections.append(SectionHandler(title: "Project Budget", detail: ["0"]))
        sections.append(SectionHandler(title: "Skills Required", detail: initialSelectedSkill))
        print("viewDidLoad")
    }
    
    override func loadView() {
        super.loadView()
        print("loadView")
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        print("viewWillLayoutSubviews
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("viewWillAppear")
//        
//        let selectedSkill2 = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]()
//        print(selectedSkill2)
//        if selectedSkill2.first != "" && !selectedSkill2.isEmpty {
//            print("12")
//            let selectedSkill = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]() // retrieve
//            sections.append(SectionHandler(title: "Skills Required", detail: selectedSkill))
////            tableView.reloadData()
//        } else {
//            print("34")
//
//            userDefaults.set(selectedSkillEmpty, forKey: Keys.selectedSkills) // save
//            let selectedSkill = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]() // retrieve
//            sections.append(SectionHandler(title: "Skills Required", detail: selectedSkill))
//        }
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset userDefaults
        userDefaults.removeObject(forKey: Keys.pickerStoredIndex)
        userDefaults.removeObject(forKey: Keys.selectedSkills)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        navigationItem.largeTitleDisplayMode = .never
        
//        NotificationCenter.default.addObserver(self, selector: #selector(UpdateDefaultsArrayObserver), name: NSNotification.Name("UpdateDefaultsArrayNotification"), object: nil)
//        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func addSkillData(_ skillTitle: String?) {
        guard let skill = skillTitle else { return }
        let existingSkill = self.sections[3].sectionDetail.first
        
        if skill != existingSkill && skill != "" {
            // Insert items instead of append to give a smooth reload transition
            self.sections[3].sectionDetail.insert(skill, at: 0)
            // Reloads items from the top (beginUpdates & endUpdates are be called because an insertion is happening)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
            self.tableView.endUpdates()
        } else {
            print("existing Name")
        }
    }
    
    fileprivate func presentAlertSheet() {
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
    
    fileprivate func presentActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: "Attach file (jpeg, png)", preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
        actionSheet.fixActionSheetConstraintsError()
    }
    
    // MARK: - Selectors
    @objc func addSkillsBtnTapped() {
//        presentAlertSheet()
        let vc = SkillSelectionVC()
//        vc.modalPresentationStyle = .fullScreen
//        vc.customArray = selectedSkill
        vc.skillSelectionVCDelegate = self
        if initialSelectedSkill.last == "" && initialSelectedSkill.count == 1 {
            print("array is empty")
        } else {
            print("array is not empty")
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
                // UI components must be in the main Grand Center Dispatch (GCD)
                DispatchQueue.main.async { [self] in
//                    print(vc.sections[1].sectionDetail.count)
                    for skills in initialSelectedSkill {
                        if skills != "" {
                            vc.sections[0].sectionDetail.insert(skills, at: 0)
                            vc.tableView.beginUpdates()
                            vc.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                            vc.tableView.endUpdates()
                            vc.updateAddButtonState()
                        }
                    }
                }
            }
        }
        
        let vcWithEmbeddedNav = UINavigationController(rootViewController: vc)
//        vcWithEmbeddedNav.modalPresentationStyle = .fullScreen
//        vcWithEmbeddedNav.modalTransitionStyle = .crossDissolve
        present(vcWithEmbeddedNav, animated: true, completion: nil)
    }
    
    @objc func attachFileBtnTapped() {
        presentActionSheet()
    }
    
    
}

// MARK: - SkillSelectionVCSingleton Extension
extension PostFormVC: SkillSelectionVCDelegate {
    
    fileprivate func arrayOfStringContains(_ item: String)  -> Bool {
        let arrayOfString = initialSelectedSkill
        return arrayOfString.contains { $0 == item }
    }
    
    func fetchSelectedSkills(skills: [String], didDelete: Bool) {
        
        print("workingggg: \(skills), \(didDelete)")

        //        if selectedSkillEmpty.isEmpty
//        selectedSkillEmpty.append(contentsOf: skills)
        if !skills.isEmpty {
            for skill in skills {
                if !arrayOfStringContains(skill) || didDelete == false {
                    initialSelectedSkill.append(skill)
                    let uniquePosts = initialSelectedSkill.unique{$0}
                    initialSelectedSkill.removeAll()
                    initialSelectedSkill.append(contentsOf: uniquePosts)
                    self.sections[3].sectionDetail.insert(skill, at: 0)
                    print("new item: \(initialSelectedSkill), \(uniquePosts) "+skill)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
                    self.tableView.endUpdates()
                    print(self.sections[3].sectionDetail.count)
                    
                    if uniquePosts.count < self.sections[3].sectionDetail.count {
                        self.sections[3].sectionDetail.removeAll()
                        self.sections[3].sectionDetail.append(contentsOf: uniquePosts)
                        self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                    }
                    
                } else {
//                    initialSelectedSkill.removeAll()
//                    selectedSkillEmpty.append(skill)
//                    tableView.reloadData()
                    print("inside else")
//                    let indexToDelete = initialSelectedSkill.firstIndex(of: skill) ?? 400
                    
//                    initialSelectedSkill.forEach { skilll in
//
//                        if skill == skilll || skilll == "" {
//                            print("good")
//                        } else {
//                            if skill != initialSelectedSkill.first && skill != "" {
//                                print("new item 2")
                            let indexToDelete = initialSelectedSkill.firstIndex(of: skill) ?? 400
                            print("item already exists: \(indexToDelete)")
                            print("item already exists: \(initialSelectedSkill)")
                            print("item already exists: \(initialSelectedSkill.count)")

                            initialSelectedSkill.remove(at: indexToDelete)
                            self.sections[3].sectionDetail.removeAll()
                            self.sections[3].sectionDetail.append(contentsOf: initialSelectedSkill)
                            self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
//                        }
//                    }
                }
            }
            let uniquePosts = initialSelectedSkill.unique{$0 ?? ""}

            print("workingggg2: \(initialSelectedSkill)")
            print("notEmpty: \(uniquePosts)")
        } else {
            
            initialSelectedSkill.forEach { skill in
                if skill != "" {
                    let indexToDelete = initialSelectedSkill.firstIndex(of: skill) ?? 400
                    initialSelectedSkill.remove(at: indexToDelete)
                    self.sections[3].sectionDetail.removeAll()
                    self.sections[3].sectionDetail.append(contentsOf: initialSelectedSkill)
                    self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                    
                    print("Empty1: \(self.sections[3].sectionDetail)")
                    print("Empty1: \(initialSelectedSkill)")
                }
            }
        }
        
    }
    
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension PostFormVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count//handymanSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles =  sections[indexPath.section]
        let title = titles.sectionDetail[indexPath.row]
        
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
            
//            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
//            let lastIndex = lastRowIndex - 1
//
            if indexPath.row >= 3 {
                cell.setupNewViews()
//                cell.textLabel?.font = .systemFont(ofSize: 11.4)
//                cell.textLabel?.text = imageNameArray[indexPath.row - 3]
//                cell.imageView?.image = UIImage(data: imageDataArray[indexPath.row - 3])
                cell.textLabel?.isHidden = true
                cell.imageView?.isHidden = true
                cell.customLabel2.text = imageNameArray[indexPath.row - 3]
                cell.customImageView.image = UIImage(data: imageDataArray[indexPath.row - 3])
                print("if")
            }
//            else {
//                cell.stackView.isHidden = false
//                cell.setupViews()
//                cell.attachFileBtn.addTarget(self, action: #selector(attachFileBtnTapped), for: .touchUpInside)
//            }
            
//            print("indexPath: \(indexPath.row)")
//            print("lastIndex: \(lastIndex)")

            switch indexPath.row {
            case 0:
                let projectTitleTextField = UITextField()
                projectTitleTextField.placeholder = "Title"
                projectTitleTextField.backgroundColor = .white
                
                cell.addSubview(projectTitleTextField)
                //                cell.sendSubviewToBack(viewC)
                projectTitleTextField.anchor(top: cell.topAnchor, leading: cell.textLabel?.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.textLabel?.trailingAnchor)
//                projectTitleTextField.backgroundColor = .red
            case 1:
                let projectDescriptionTextField = UITextField()
                projectDescriptionTextField.placeholder = "Description"
                projectDescriptionTextField.backgroundColor = .white
                
                cell.addSubview(projectDescriptionTextField)
                //                cell.sendSubviewToBack(viewC)
                projectDescriptionTextField.anchor(top: cell.topAnchor, leading: cell.textLabel?.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.textLabel?.trailingAnchor)
            case 2:
                cell.setupViews()
                cell.attachFileBtn.addTarget(self, action: #selector(attachFileBtnTapped), for: .touchUpInside)
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
            
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections - 1)
            let lastIndex = lastRowIndex - 1
           
            if indexPath.row == lastIndex {
                cell.textLabel?.isHidden = true
                cell.setupViews()
                cell.addSkillsBtn.addTarget(self, action: #selector(addSkillsBtnTapped), for: .touchUpInside)
            } else {
                cell.textLabel?.text = title
                cell.addSkillsBtn.isHidden = true
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func UpdateDefaultsArrayObserver() {
//        tableView.reloadData()
        print("workin")

        let selectedSkill2 = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]()
        print(selectedSkill2)
        if selectedSkill2.first != "" || !selectedSkill2.isEmpty {
            print("56")
//            let selectedSkill = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]() // retrieve
//            sections.append(SectionHandler(title: "Skills Required", detail: selectedSkill))
//            sections[3].sectionDetail.append(contentsOf: selectedSkill2)
//            sections[3].sectionDetail += selectedSkill
            tableView.reloadData()
//            let uniquePosts = selectedSkill2.unique{$0 ?? ""}

            print(selectedSkill2.filter { $0 != $0})
            for skills in selectedSkill2 {
                self.sections[3].sectionDetail.insert(skills, at: 0)
                print("try: \(self.sections[3].sectionDetail)")
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
                self.tableView.endUpdates()
            }
//            tableView.reloadData()

        } else {
            print("67")

            userDefaults.set(initialSelectedSkill, forKey: Keys.selectedSkills) // save
            let selectedSkill = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]() // retrieve
            sections[3].sectionDetail.append(contentsOf: selectedSkill)
            tableView.reloadData()

        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
            return sections[section].sectionTitle
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if indexPath.row >= 3 {
                return 60
            }
            return 40
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 40
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Gives the slide delete feature to the section 0 (but not the 2nd cell in it) and 3 (but not the last cell in it) cells
        switch indexPath.section {
        case 0:
            if indexPath.row <= 2 {
                return false
            } else {
                return true
            }
        case 3:
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            let lastIndex = lastRowIndex - 1
            if indexPath.row == lastIndex {
                return false
            } else {
                return true
            }
        default:
            break
        }
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)

            switch indexPath.section {
            case 0:
                // Delete item in the arrays
                imageDataArray.remove(at: indexPath.row - 3)
                imageNameArray.remove(at: indexPath.row - 3)
                attachedFileArray["imageData"] = imageDataArray
                attachedFileArray["imageName"] = imageNameArray
                //
                sections[0].sectionDetail.remove(at: indexPath.row)
                // Reload smoothly the cells after removal of an item in the array (beginUpdates & endUpdates are be called because an deletion is happening)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.endUpdates()
                
                print(self.sections[0].sectionDetail)
                print("attachedFileArray2: \(attachedFileArray)")
            case 3:
                sections[3].sectionDetail.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.endUpdates()
            default:
                break
            }
            
           
        }
    }
    
}

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
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

// MARK: - UIImagePickerControllerDelegate Extension
extension PostFormVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            let fileName = fileUrl.lastPathComponent
            let fileType = fileUrl.pathExtension
            
            var selectedImage = Data()
            // Convert selectedImage into Data type
            fileType == "jpeg" ? (selectedImage = image.jpegData(compressionQuality: 0.4)!) : (selectedImage = image.pngData()!)

            imageDataArray.insert(selectedImage, at: 0)
            imageNameArray.insert(fileName, at: 0)
            attachedFileArray["imageData"] = imageDataArray
            attachedFileArray["imageName"] = imageNameArray
            
            self.sections[0].sectionDetail.insert(fileName, at: 3)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .top)
            self.tableView.endUpdates()
            
        
            print(self.sections[0].sectionDetail)
            print("attachedFileArray: \(attachedFileArray)")
        }
        
        print("did pick")
        // Insert items instead of append to give a smooth reload transition
//        self.sections[3].description.insert(skill, at: 0)
        // Reloads items from the top (beginUpdates & endUpdates are be called because an insertion is happening)
//        self.tableView.beginUpdates()
//        self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .top)
//        self.tableView.endUpdates()
//        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
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
