//
//  AccountVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/18/21.
//

import UIKit
import DropDown

class TechnieAccountVC: UIViewController {

    // MARK: - Properties
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
        
        tv.register(TechnieAccountCell.self, forCellReuseIdentifier: TechnieAccountCell.cellID)
        return tv
    }()
    
    // MARK: - Inits
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print("viewWillAppear")
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0)}
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Account"
    }
    
    // MARK: - Selectors
    
    let accountTypes = ["Personal", "Enterprise"]
    var newAccountType = ""
    var newHourlyRate = ""
    
    lazy var accountTypeDrowDown: DropDown = {
        let dropDown = DropDown(frame: CGRect(x: 0, y: 0, width: 110, height: 0))
        dropDown.dataSource = accountTypes
        dropDown.clipsToBounds = true
        dropDown.layer.cornerRadius = 20

        dropDown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            print(item)
            self.newAccountType = item
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.endUpdates()
            dropDown.hide()
        }
        
        return dropDown
    }()
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension TechnieAccountVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TechnieAccountCell.cellID, for: indexPath) as! TechnieAccountCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Name"
            cell.descriptionLabel.text = "username"
        case 1:
            cell.titleLabel.text = "Email"
            cell.descriptionLabel.text = "username@gmail.com"
        case 2:
            var userAccountType = "Personal"
            newAccountType == "" ? (userAccountType = userAccountType) : (userAccountType = newAccountType)
            cell.titleLabel.text = "Type"
            cell.descriptionLabel.text = userAccountType
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            accountTypes.forEach { item in
                if cell.descriptionLabel.text == item {
                    let indexOf = accountTypes.firstIndex(of: item)
                    accountTypeDrowDown.selectRow(indexOf!)
                }
            }

            accountTypeDrowDown.anchorView = cell.descriptionLabel
            accountTypeDrowDown.bottomOffset = CGPoint(x: -40, y: cell.descriptionLabel.intrinsicContentSize.height + 8)
        
        case 3:
            var userHourlyRate = "200"
            newHourlyRate == "" ? (userHourlyRate = userHourlyRate) : (userHourlyRate = newHourlyRate)
            cell.titleLabel.text = "Hourly Rate"
            cell.descriptionLabel.text = "₱\(userHourlyRate)"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            accountTypeDrowDown.show()
        } else if indexPath.row == 3 {
            presentEnterHourlyRateAlertController()
        }
    }
    
    func containsOnlyLetters(input: String) -> Bool {
       for chr in input {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
             return false
          }
       }
       return true
    }
    
    fileprivate func presentEnterHourlyRateAlertController() {
        var rateField = UITextField()
        rateField.placeholder = "₱"
        
        let alertController = UIAlertController(title: "Hourly Rate", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { [self] (action) in
            guard let rateInput = alertController.textFields?[0] else { return }

            if containsOnlyLetters(input: rateInput.text!) == false {
                newHourlyRate = rateInput.text!
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            } else {
                print("There's letters")
                let alert = UIAlertController(title: "Wrong Entry!", message: "You cannot insert letter as your hourly rate, please enter numbers only.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
            
         
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (addTextField) in
            addTextField.clearButtonMode = .whileEditing
            addTextField.keyboardType = .numberPad
            addTextField.placeholder = "₱"
            rateField = addTextField
        }
        
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
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

