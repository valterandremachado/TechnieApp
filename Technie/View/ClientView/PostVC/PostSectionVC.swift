//
//  PostSectionVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/27/20.
//

import UIKit

class PostSectionVC: UIViewController {

    private let tableCellID = "tableCellID"
    var sectionTitle = ""
    var postSectionVCIndexPath = IndexPath(item: 0, section: 0)
    
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
        tv.register(PostSectionCell.self, forCellReuseIdentifier: tableCellID)
        return tv
    }()
    
    let stringArray = ["Refrigerator", "Washing Machine", "Freezer", "Ice Cream Machine", "TV", "Microwave", "Heat Pump", "Commercial Oven", "Dryer Machine"]

    let stringArray2 = ["Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala"]

    let stringArray3 = ["Lelele", "Lelele", "Lelele", "Lelele", "Lelele", "Lelele", "Lelele", "Lelele"]

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        setupViews()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
//        let backButton = UIBarButtonItem()
//        guard let navBar = navigationController?.navigationBar else { return }
//        backButton.title = sectionTitle
//        navBar.topItem?.backButtonTitle = sectionTitle
//        navBar.backgroundColor = .white
        //navBar.prefersLargeTitles = false
        navigationItem.title = sectionTitle
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    // MARK: - Selectors

    
}

extension PostSectionVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch postSectionVCIndexPath.item {
        case 0:
            return stringArray2.count
        case 1:
            return stringArray3.count
        case 2:
            return stringArray.count
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! PostSectionCell
//        cell.textLabel?.text = stringArray[indexPath.row]
        
        switch postSectionVCIndexPath.item {
        case 0:
            cell.textLabel?.text = stringArray2[indexPath.row]
        case 1:
            cell.textLabel?.text = stringArray3[indexPath.row]
        case 2:
            cell.textLabel?.text = stringArray[indexPath.row]
        case 3:
            cell.textLabel?.text = "One"
        default:
            break
        }
        
        return cell
    }
    
    
}
