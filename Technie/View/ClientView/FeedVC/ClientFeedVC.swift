//
//  ViewController.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit
import LBTATools


class ClientFeedVC: UIViewController {

    // Cells ID
    private let feedCellOnSection1ID = "feedCellID1"
    private let feedCellOnSection2ID = "feedCellID2"
    private let headerID = "headerID"
    
    let sections = ["Technician's Ranking", "Nearby Technicians"]

    // MARK: - Properties
    lazy var clientFeedCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 5
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear 
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        cv.delegate = self
        cv.dataSource = self
        
        // Registration of the cells
        cv.register(NearbyTechniesCell.self, forCellWithReuseIdentifier: feedCellOnSection1ID)
        cv.register(TechnieRankingCell.self, forCellWithReuseIdentifier: feedCellOnSection2ID)
        // header
        cv.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        return cv
    }()
    
    let stringArray = ["Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala"]
    let detailArray = ["LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala"]
    let imageArray = ["person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill"]

    lazy var clientFeedTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView()
        tv.rowHeight = 100

        
        tv.delegate = self
        tv.dataSource = self
        tv.register(FeedCell2.self, forCellReuseIdentifier: feedCellOnSection1ID)
        return tv
    }()
    
    let config = UIImage.SymbolConfiguration(pointSize: CGFloat(30))
    lazy var wiredProfileImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    lazy var userProfileNavBarBtn: UIButton = {
    let btn = UIButton(type: .custom)
    btn.imageView?.contentMode = .scaleAspectFill
    btn.setImage(wiredProfileImage, for: .normal)
    btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    btn.layer.cornerRadius = btn.frame.size.height/2
    btn.layer.masksToBounds = false
    btn.clipsToBounds = true
    btn.sizeToFit()
    
    /// height and width constrainnts of profileBtn
    let widthConstraint = btn.widthAnchor.constraint(equalToConstant: 30)
    let heightConstraint = btn.heightAnchor.constraint(equalToConstant: 30)
    heightConstraint.isActive = true
    widthConstraint.isActive = true
    
//    profileBtn.addTarget(self, action: #selector(profileImagePressed), for: .touchUpInside)
        return btn
    }()
    // MARK: - Init
    override func loadView() {
        super.loadView()
        setupNavBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "BackgroundAppearance")
        setupViews()
    }

    // MARK: - Methods
    fileprivate func setupViews(){
        [clientFeedCollectionView].forEach {view.addSubview($0)}
        
        clientFeedCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    func setupNavBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Feeds"
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Left navigation bar item
        let leftBarItemUserProfile = UIBarButtonItem(image: wiredProfileImage, style: .plain, target: self, action: #selector(leftBarItemPressed))
//        let customBarItem = UIBarButtonItem(customView: userProfileNavBarBtn)
        navigationItem.leftBarButtonItem = leftBarItemUserProfile
        
        
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftBarItemPressed(){
        let userProfileVC = UserProfileVC()
//        userProfileVC.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.pushViewController(userProfileVC, animated: true)
    }

}

// MARK: - CollectionViewDelegateAndDataSource Extension
extension ClientFeedVC: CollectionDataSourceAndDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? (1) : (5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        switch indexPath.section {
        case 0:
            // Technie Ranking cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellOnSection2ID, for: indexPath) as! TechnieRankingCell
            return cell
        case 1:
            // Nearby Technie cell
            let cell = clientFeedCollectionView.dequeueReusableCell(withReuseIdentifier: feedCellOnSection1ID, for: indexPath) as! NearbyTechniesCell
            return cell
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewSize = view.frame.size
        var collectionViewSize = CGSize(width: viewSize.width - 10, height: 290)
        
        if indexPath.section != 0 {
            collectionViewSize = CGSize(width: viewSize.width - 10, height: 150)
        }
        
        return collectionViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Section 0 EdgeInsets
        var collectionViewEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 25, right: 0)
        
        if section != 0 {
            // Section 1 EdgeInsets
            collectionViewEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 10, right: 0)
            return collectionViewEdgeInsets
        }
        
        // Returns section 0 Inserts to if the section is equal to 0
        return collectionViewEdgeInsets
    }
    
    // MARK: - Multi-section handler (CollectionView Methods)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                            String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                                                                        headerID, for: indexPath) as! Header
        
        switch indexPath.section {
        case 0:
            header.sectionTitle.text = sections[indexPath.section]
            return header
        case 1:
            header.sectionTitle.text = sections[indexPath.section]
            return header
        default:
            break
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
}

// MARK: - TableViewDelegateAndDataSource Extension
extension ClientFeedVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: feedCellOnSection1ID, for: indexPath) as! FeedCell2
        // Enables detailTextLabel visibility
        cell = FeedCell2(style: .subtitle, reuseIdentifier: feedCellOnSection1ID)
        
        
        // Customize Cell
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
        cell.backgroundColor = .white
        
        // Pass data
        cell.textLabel?.text = stringArray[indexPath.row]
        cell.detailTextLabel?.text = detailArray[indexPath.row]
        cell.imageView?.image = UIImage(systemName: imageArray[indexPath.row])
        return cell
    }
    
    
}


// MARK: - ClientFeedPreviews
import SwiftUI

struct ClientFeedPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = ClientFeedVC()
        return vc.liveViewController
    }
    
}
