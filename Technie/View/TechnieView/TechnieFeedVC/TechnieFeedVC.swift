//
//  TechnieFeedVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit
import FirebaseDatabase

protocol TechnieFeedVCDelegate {
    func saveJobLinkMethod(cell: UITableViewCell, button: UIButton)
}

class TechnieFeedVC: UIViewController, TechnieFeedVCDelegate {
    
    // Cells ID
    private let feedCellOnSection1ID = "feedCellID1"
    private let feedCellOnSection2ID = "feedCellID2"
    private let searchResultCellID = "searchCellID"
    private let headerID = "headerID"
    
    private let searchResultHeaderID = "searchViewHeaderID"
    
    let sections = ["Technician's Ranking", "Nearby Technicians"]
    var postModel = [PostModel]()
    var filteredData: [PostModel] = []

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

    private var indicator: ProgressIndicatorLarge!
        
    lazy var warningLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Our service is offline, please try again later."
        return lbl
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
        
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        if postModel.count == 0 {
            indicator.start()
        }
        
        fetchData()
        setupViews()
//        UserDefaults.standard.removeObject(forKey: "persistUsersInfo")
//        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
//        print("persistUsersInfo: \(getUsersPersistedInfo)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listenToPostsChange()
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)

        }, completion: nil)
        
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        [tableView, searchResultView, indicator].forEach {view.addSubview($0)}
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return } // SafeAreaPadding
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: tabHeight, right: 0))
//        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        searchResultView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
        ])
        
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
    
    var savedJobsUIDs = [String]()
    var savedJobs = [PostModel]()

    fileprivate func fetchData()  {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid
        
        DispatchQueue.main.async {
            DatabaseManager.shared.getAllSavedJobs(technicianKeyPath: technicianKeyPath) { [self] result in
                switch result {
                case .success(let savedJobs):
                    self.savedJobs = savedJobs
                    print("success")

                    for i in 0..<tableView.numberOfSections {
                        for j in 0..<tableView.numberOfRows(inSection: i) {
                            
                            let indexPath = IndexPath(row: j, section: i)
                            let model = postModel[indexPath.row]
                            
                            for job in savedJobs {
                                if savedJobsUIDs.count > 0 {
                                    savedJobsUIDs.forEach { title in
                                        if title != model.title && savedJobsUIDs.count < savedJobs.count {
                                            if job.title == model.title {
//                                                print("title: \(job.title)")
                                                self.buttonStates[indexPath.row] = true
                                                savedJobsUIDs.append(job.title)
                                            } else {
                                                self.buttonStates[indexPath.row] = false
                                            }
                                        } // End of inner conditional statement
                                    } // End of inner loop
                                } else {
                                    if job.title == model.title {
//                                        print("title2: \(job.title)")
                                        self.buttonStates[indexPath.row] = true
                                        savedJobsUIDs.append(job.title)
                                    } else {
                                        self.buttonStates[indexPath.row] = false
                                    }
                                } // End of first conditional statement
                            } // End of for loop
                            
                            tableView.reloadData()
                            
                        }
                    }
                    

                case .failure(let error):
                    print(error)
                }
            }
            
            DatabaseManager.shared.getAllPosts(completion: {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let posts):
                    let sortedArray = posts.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                    self.postModel = sortedArray
                    
                    for _ in 0..<(sortedArray.count) {
                        self.buttonStates.append(false)
                        // in my case, all buttons are off, but be sure to implement logic here
                    }
                    
                    self.indicator.stop()
                    self.tableView.reloadData()
        
                    return
                case .failure(let error):
                    if self.savedJobs.count == 0 {
                        self.tableView.isHidden = true
                        self.view.addSubview(self.warningLabel)
                        NSLayoutConstraint.activate([
                            self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                            self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                        ])
                    } else {
                        self.tableView.isHidden = false
                    }
                    
                    self.indicator.stop()
                    print("Failed to get posts: \(error.localizedDescription)")
                }
            })
        }
    }
    
    fileprivate func listenToPostsChange() {
        DispatchQueue.main.async {
            DatabaseManager.shared.listenToPostChanges(completion: { result in
                switch result {
                case .success(let posts):
                    // Remove existing items to avoid duplicated items
                    self.postModel.removeAll()
                    print("childChanged")
                    let sortedArray = posts.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                    self.postModel = sortedArray
                    self.tableView.reloadData()
                    return
                case .failure(let error):
                    print("Failed to get posts: \(error.localizedDescription)")
                }
            })
        }
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
    
    var buttonStates = [Bool]()
    let imageSaved = UIImage(systemName: "bookmark.fill")
    let imageUnsaved = UIImage(systemName: "bookmark")
    // MARK: - Like button delegate
    func saveJobLinkMethod(cell: UITableViewCell, button: UIButton) {
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid
        guard let tappedIndexPath = tableView.indexPath(for: cell) else { return }
        
        buttonStates[tappedIndexPath.item] = !buttonStates[tappedIndexPath.item]

        if buttonStates[tappedIndexPath.item] == true {
            buttonStates[tappedIndexPath.item] = true
            button.setImage(imageSaved, for: .normal)
            guard let postUID = postModel[tappedIndexPath.row].id else { return }
            DatabaseManager.shared.insertSavedPost(withKeyPath: technicianKeyPath, withPostUID: postUID) { success in
                if success {
                    print("success")
                }
            }
            
        } else {
//            buttonStates[tappedIndexPath.item] = false
            button.setImage(imageUnsaved, for: .normal)

        }
        
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
        searchBar.resignFirstResponder()
        searchBar.searchTextField.autocapitalizationType = .none
        guard let searchedString = searchBar.text else { return }
        presentSearchResults(searchedString, filteredData)
    }
    
    fileprivate func presentSearchResults(_ searchedString: String,_ filteredPost: [PostModel]) {
        let vc = JobSearchResultsVC()
        vc.title = "\(searchedString) results".lowercased()
        vc.postModel = filteredPost
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        searchBar.text = searchText.lowercased()
        if searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            //            print("isEmpty")
//            collectionView.isHidden = true
//            collectionView.reloadData()
        } else {
//            collectionView.isHidden = false
//            collectionView.reloadData()
        }
        
        filteredData = postModel
        if searchText.isEmpty == false {
            filteredData = postModel.filter({ $0.field!.contains(searchText) })
//            print(filteredData)
//            isSearching = true
//            collectionView.reloadData()
        }
       
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
        
        cell.linkedDelegate = self
        let posts = postModel[indexPath.row]
        cell.postModel = posts
        
        // buttonStates switcher
        if self.buttonStates[indexPath.item] == true {
            cell.likeBtn.setImage(self.imageSaved, for: .normal)
            self.buttonStates[indexPath.item] = true
        } else {
            cell.likeBtn.setImage(self.imageUnsaved, for: .normal)
            self.buttonStates[indexPath.item] = false
        }
        
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = JobDetailsVC()
        vc.postModel = postModel[indexPath.row]
        vc.navBarViewSubtitleLbl.text = "posted \(view.calculateTimeFrame(initialTime: postModel[indexPath.row].dateTime))"
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
        let professions = professionArray[indexPath.item]
        let filteredByProfession = professions == "Others" ? (postModel) : (postModel.filter({ $0.field!.contains(professions)}))
        let vc = JobSearchResultsVC()
        vc.title = "\(professionArray[indexPath.item]) job results".lowercased()
        vc.postModel = filteredByProfession
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

