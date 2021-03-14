//
//  TechnicianContinueSignUpVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit
import DropDown

class TechnicianContinueSignUpVC: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(TechnicianContinueCell.self, forCellReuseIdentifier: TechnicianContinueCell.cellID)
        return tv
    }()
    
    lazy var headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Write about yourself in few words."
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Summary..."
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    lazy var summaryTextField: UITextView = {
        let txtView = UITextView()
        txtView.delegate = self
        txtView.font = .systemFont(ofSize: 15)
        txtView.textAlignment = .natural
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.backgroundColor = UIColor(named: "textViewBackgroundColor")
        txtView.clipsToBounds = true
        txtView.layer.cornerRadius = 10
        txtView.isEditable = true
        txtView.isScrollEnabled = false
        return txtView
    }()
    
    lazy var signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.setTitle("Create my account", for: .normal)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .systemPink
        return btn
    }()
    
    let accountTypes = ["Personal", "Enterprise"]
    
    lazy var accountTypeDrowDown: DropDown = {
        let dropDown = DropDown(frame: CGRect(x: 0, y: 0, width: 110, height: 0))
        dropDown.dataSource = accountTypes
        dropDown.clipsToBounds = true
        dropDown.layer.cornerRadius = 20

        dropDown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            print(item)
//            self.changeUserAccountType(accountType: item)

            self.accountType = item
//            self.tableView.beginUpdates()
            self.tableView.reloadData()//reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
//            self.tableView.endUpdates()
            dropDown.hide()
        }
        
        return dropDown
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
        self.hideKeyboardWhenTappedAround()
    }
 

    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0) }
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navbar = navigationController?.navigationBar else { return }
        navigationItem.title = "Profile Info"
        navbar.prefersLargeTitles = false
    }
    
    // MARK: - Selectors

    var yearsOfExp: String?
    var expertise: [String]?
    var accountType: String?
    var hourlyRate: String?
}

// MARK: - ExpertiseVCDelegate Extension
extension TechnicianContinueSignUpVC: ExpertiseVCDelegate {
    
    func fetchSelectedSkills(skills: [String]) {
        expertise = skills
        self.tableView.reloadData()
    }
    
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnicianContinueSignUpVC: TableViewDataSourceAndDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        tableView.beginUpdates()
        tableView.endUpdates()

        if !textView.text.replacingOccurrences(of: " ", with: "").isEmpty {
            placeHolderLabel.fadeOut()
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
            placeHolderLabel.fadeIn()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TechnicianContinueCell.cellID, for: indexPath) as! TechnicianContinueCell
        cell = TechnicianContinueCell(style: .value1, reuseIdentifier: TechnicianContinueCell.cellID)
        cell.detailTextLabel?.font = .systemFont(ofSize: 12.5)
        let rowTitle = ["Years of Experience", "Expertise", "Account Type", "Hourly Rate"]

        switch indexPath.row {
        case 0:
            [headerLabel, summaryTextField, placeHolderLabel].forEach{cell.contentView.addSubview($0)}
            
            headerLabel.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: nil, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 20))
            
            summaryTextField.anchor(top: headerLabel.bottomAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
            
            placeHolderLabel.anchor(top: summaryTextField.topAnchor, leading: cell.contentView.leadingAnchor, bottom: summaryTextField.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        case 1:

            cell.textLabel?.text = rowTitle[0]
            cell.detailTextLabel?.text = yearsOfExp ?? "Choose"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case 2:
            let flatStrings = expertise?.joined(separator: ", ")
            cell.textLabel?.text = rowTitle[1]
            cell.detailTextLabel?.text = flatStrings ?? "Choose"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case 3:
            cell.textLabel?.text = rowTitle[2]
            cell.detailTextLabel?.text = accountType ?? "Choose"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            accountTypes.forEach { item in
                if cell.detailTextLabel?.text == item {
                    let indexOf = accountTypes.firstIndex(of: item)
                    accountTypeDrowDown.selectRow(indexOf!)
                }
            }

            accountTypeDrowDown.anchorView =  cell.detailTextLabel
            accountTypeDrowDown.bottomOffset = CGPoint(x: -40, y: cell.detailTextLabel?.intrinsicContentSize.height ?? 0 + 8)
        case 4:
            cell.textLabel?.text = rowTitle[3]
            cell.detailTextLabel?.text = hourlyRate ?? "Choose"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case 5:
            cell.contentView.addSubview(signupBtn)
            signupBtn.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: nil, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: cell.separatorInset.left + 5, bottom: 0, right: cell.separatorInset.left + 5), size: CGSize(width: 0, height: 40))

        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            presentExperienceAlertController()
        case 2:
            let vc = ExpertiseVC()
            vc.isComingFromSignupVC = true
            vc.expertiseVCDelegate = self
            present(UINavigationController(rootViewController: vc), animated: true)
        case 3:
            accountTypeDrowDown.show()
        case 4:
            presentEnterHourlyRateAlertController()
        default:
            break
        }
    }
    
    fileprivate func presentEnterHourlyRateAlertController() {
        var rateField = UITextField()
        rateField.placeholder = "ex: ₱300"
        
        let alertController = UIAlertController(title: "Hourly Rate", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let rateInput = alertController.textFields?[0] else { return }

                guard let rate = Int(rateInput.text!) else { return }
                hourlyRate = "₱\(rate)"
                
//                self.tableView.beginUpdates()
                self.tableView.reloadData()//reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
//                self.tableView.endUpdates()
         
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.keyboardType = .numberPad
            addTextField.placeholder = "ex: ₱300"
            rateField = addTextField
        }
        
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func presentExperienceAlertController() {
        var rateField = UITextField()
        rateField.placeholder = "Experience (ex: 0.5, 1)"
        
        let alertController = UIAlertController(title: "Experience", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let rateInput = alertController.textFields?[0] else { return }

                guard let rate = Int(rateInput.text!) else { return }
                yearsOfExp = "\(rate)"
                
//                self.tableView.beginUpdates()
                self.tableView.reloadData()//reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
//                self.tableView.endUpdates()
         
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.keyboardType = .numberPad
            addTextField.placeholder = "Experience (ex: 0.5, 1)"
            rateField = addTextField
        }
        
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
}
