//
//  UserProfileVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/17/20.
//

import UIKit

class UserProfileVC: UIViewController {
        
    let stringArray = ["Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala"]
    let detailArray = ["LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala"]
    let imageArray = ["person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill"]
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .systemBackground
        
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
//        tv.layer.cornerRadius = 18
        tv.clipsToBounds = true

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.cellID)
        return tv
    }()
    
    lazy var profileImageView: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        iv.roundedImage()
//        iv.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        //        iv.sizeToFit()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter A. Machado"
        lbl.textAlignment = .center
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City, Philippines"
        lbl.textAlignment = .center
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 13)
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
//        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var stackView1: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, locationLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 0
        sv.distribution = .equalSpacing
        return sv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        profileImageViewPicker.roundedImage()
//    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView, profileImageView, stackView1].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        
        stackView1.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 35))
        
        tableView.anchor(top: stackView1.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationItem.title = "@username"
    }
    
    // MARK: - Selectors


}


// MARK: - TableViewDelegateAndDataSource Extension
extension UserProfileVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //stringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.cellID, for: indexPath) as! ProfileTableViewCell
        // Enables detailTextLabel visibility
        cell = ProfileTableViewCell(style: .subtitle, reuseIdentifier: ProfileTableViewCell.cellID)
        cell.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)

        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        let lastIndex = lastRowIndex - 1
        
        // Customize Cell
//        cell.textLabel?.textColor = .black
//        cell.detailTextLabel?.textColor = .black
//        cell.backgroundColor = .white
        indexPath.row == lastIndex ? (cell.textLabel?.textColor = .red) : (cell.textLabel?.textColor = .black)
        indexPath.row == lastIndex ? (cell.accessoryType = .none) : (cell.accessoryType = .disclosureIndicator)
        let tableViewOptions = TableViewOptions(rawValue: indexPath.row)
        // Pass data
        cell.textLabel?.text = tableViewOptions?.description
//        cell.detailTextLabel?.text = detailArray[indexPath.row]
        cell.imageView?.image = tableViewOptions?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            print("index 0")
        case 1:
            let vc = TechnieTabController()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        case 2:
            let vc = ClientPostHistoryVC()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            print("index 3")
        default:
            break
        }
        if indexPath.row == 1 {
           
        }
    }
    
    
}

// MARK: - UserProfileVCPreviews
import SwiftUI

struct UserProfileVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = UserProfileVC()
        return vc.liveViewController
    }
    
}
