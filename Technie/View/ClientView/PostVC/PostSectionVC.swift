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
    
    let repairerSectionArray = ["Refrigerator", "Washing Machine", "Freezer", "Ice Cream Machine", "TV", "Microwave", "Heat Pump", "Commercial Oven", "Dryer Machine", "Others"]
    
    let handymanSectionArray = ["Plumbing Installation/Leaking Plumbing", "Drywall Installation", "Fixture Replacement", "Painting for the Interior and Exterior", "Power Washing", "Tile Installation", "Deck/Door/Window Repair", "Carpenter", "Cabinetmaker", "Others"]
    
    let electricianSectionArray = ["Refrigerator", "Drywall Installation", "Freezer", "Machine", "TV", "Microwave", "Pump", "Commercial", "Machine"]


    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        setupViews()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }

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
            return handymanSectionArray.count
//        case 1:
//            return stringArray3.count
        case 2:
            return repairerSectionArray.count
//        case 3:
//            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! PostSectionCell
//        cell.textLabel?.text = stringArray[indexPath.row]
        // custom selectionHighlight color
//        cell.selectedBackgroundView = UIView(frame: CGRect.zero)
//        cell.selectedBackgroundView?.backgroundColor = UIColor(red:0.27, green:0.71, blue:0.73, alpha:1.0)

        switch postSectionVCIndexPath.item {
        case 0:
            cell.textLabel?.text = handymanSectionArray[indexPath.row]
//        case 1:
//            cell.textLabel?.text = stringArray3[indexPath.row]
        case 2:
            cell.textLabel?.text = repairerSectionArray[indexPath.row]
//        case 3:
//            cell.textLabel?.text = "One"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch postSectionVCIndexPath.item {
        case 0:
            let vc = PostFormVC()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = PostFormVC()
            navigationController?.pushViewController(vc, animated: true)
        default:
           break
        }
        
    }
    
    
}
