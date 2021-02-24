//
//  TechnieFeedVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit

class TechnieFeedVC: UIViewController {
    
    // Cells ID
    private let feedCellOnSection1ID = "feedCellID1"
    private let feedCellOnSection2ID = "feedCellID2"
    private let searchResultCellID = "searchCellID"
    private let headerID = "headerID"
    
    private let searchResultHeaderID = "searchViewHeaderID"
    
    let sections = ["Technician's Ranking", "Nearby Technicians"]
    var postModel = [PostModel]()
    // MARK: - Properties
    var customindexPath = IndexPath(item: 0, section: 0)
    
    lazy var layoutForCollection: UICollectionViewFlowLayout = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 5
        let viewSize = view.frame.size
        let collectionViewSize = CGSize(width: viewSize.width, height: 100)
        collectionLayout.itemSize = collectionViewSize
        
        return collectionLayout
    }()
    
    lazy var searchResultCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 8
        collectionLayout.minimumInteritemSpacing = 8
        collectionLayout.estimatedItemSize = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Avoid collectionView to self adjust its size
        cv.contentInsetAdjustmentBehavior = .never
        
        cv.delegate = self
        cv.dataSource = self
        //        cv.collectionViewLayout.invalidateLayout()
        // Registration of the cell
        cv.register(SearchResultCell.self, forCellWithReuseIdentifier: searchResultCellID)
        // header
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        return cv
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 400
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
        tv.register(FeedsTVCell.self, forCellReuseIdentifier: FeedsTVCell.cellID)
        return tv
    }()
    
    let stringArray = ["Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala", "Lalala"]
    let detailArray = ["LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala", "LalalaLalalaLalala"]
    let imageArray = ["person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill", "person.crop.circle.fill"]
    
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
    
    var searchController: UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        
        // Setup SearchBar
        let searchBar = search.searchBar
        searchBar.placeholder = "Search for jobs"
        searchBar.sizeToFit()
        searchBar.delegate = self
        return search
    }
    
    var isShowingSearchResultView = false
    
    lazy var searchResultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        //        view.isHidden = true
        view.alpha = 0
        
        // Checks if resultView is showed
        didShowSearchResultViewObservable.observe(on: self) { isLoading in
            if isLoading != false {
                // Add collection view to the resultView
                view.addSubview(self.searchResultCollectionView)
                //                guard let navBarHeight = self.navigationController?.navigationBar.frame.height else { return }
                //                self.searchResultCollectionView.withHeight(view.frame.height)
                self.searchResultCollectionView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
            }
            
        }
        
        return view
    }()
    
    let screenSize = UIScreen.main.bounds.size
    private var didShowSearchResultViewObservable = Observable(false)
    
    let professionArray = ["Handyman", "Electrician", "Repairer", "Others"]//Household Appliances Repairers

        
    // MARK: - Init
    override func loadView() {
        super.loadView()
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "BackgroundAppearance")
        fetchData()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)

        }, completion: nil)
        
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        [tableView, searchResultView].forEach {view.addSubview($0)}
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return } // SafeAreaPadding
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: tabHeight, right: 0))
//        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        searchResultView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0))
    }
    
    func setupNavBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Feeds"
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchController
    }
    
    fileprivate func showSearchResultView() {
        
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [self] in
            didShowSearchResultViewObservable.value = true
            searchResultView.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func hideSearchResultView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [self] in
            searchResultView.alpha = 0
            didShowSearchResultViewObservable.value = false
            /// Completion outside of the completion block to avoid delay
            // Remove the collectionViewFrom it's parentView for a better memory efficiency
            searchResultCollectionView.removeFromSuperview()
            
        }, completion: nil)
        
    }
    
    fileprivate func fetchData()  {
        DatabaseManager.shared.getAllPosts(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.postModel.append(posts)
                self.tableView.reloadData()
            case .failure(let error):
                print("Failed to get post: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftBarItemPressed(){
        let userProfileVC = UserProfileVC()
        //        userProfileVC.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    @objc func seeAllBtnPressed() {
        let vc = FullRankingVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate Extension
extension TechnieFeedVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSearchResultView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchResultView()
    }
    
//    func presentSearchController(_ searchController: UISearchController) {
//        searchController.searchBar.becomeFirstResponder()
//    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.autocapitalizationType = .none
        guard let searchedString = searchBar.text else { return }
        presentSearchResults(searchedString)
    }
    
    fileprivate func presentSearchResults(_ searchedString: String) {
        let vc = JobSearchResultsVC()
        vc.title = "\(searchedString) results".lowercased()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableViewDelegateAndDataSource Extension
extension TechnieFeedVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTVCell.cellID, for: indexPath) as! FeedsTVCell
        let post = postModel[indexPath.row]
        cell.postModel = post
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = JobDetailsVC()
        vc.postModel = postModel[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove bottom extra 20px space.
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return .leastNormalMagnitude
    }
    
//    // UITableViewAutomaticDimension calculates height of label contents/text
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}


// MARK: - CollectionViewDelegateAndDataSource Extension
extension TechnieFeedVC: CollectionDataSourceAndDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return professionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchResultCellID, for: indexPath) as! SearchResultCell
        cell.backgroundColor = .systemGray4
        cell.title.text = professionArray[indexPath.item]
        cell.dynamicWidth.constant = cell.frame.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt: \(indexPath.row)")
        let vc = JobSearchResultsVC()
        vc.title = "\(professionArray[indexPath.item]) job results".lowercased()
        navigationController?.pushViewController(vc, animated: true)
//        presentSearchResults()
    }
    
    // CollectionView layouts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        /// changing sizeForItem when user switches through the segnment
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        //        flowLayout.sectionInset.left = 5
        //        flowLayout.sectionInset.right = 5
        
        let size = ((collectionView.bounds.width) - totalSpace) / CGFloat(noOfCellsInRow)
        let finalSize = CGSize(width: size, height: size)
        
//        let viewSize = view.frame.size
//        var collectionViewSize = CGSize(width: 0, height: 0)
        
        return finalSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var collectionViewEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 25, right: 0)
        
        collectionViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return collectionViewEdgeInsets
    }
    
    // MARK: - Multi-section handler (CollectionView Methods)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                            String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! HeaderView
        header.sectionTitle.text = "Search by category".uppercased()
        //            header.backgroundColor = .red
        //            header.sectionTitle.backgroundColor = .brown
        //            header.stackView.addBackground(color: .cyan)
        header.headerDynamicLeadingAnchor.constant = 0
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}



// MARK: - TechnieFeedVCPreviews
import SwiftUI

struct TechnieFeedVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = TechnieFeedVC()
        return vc.liveViewController
    }
    
}
