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
    private let searchResultCellID = "searchCellID"
    private let headerID = "headerID"
    
    private let searchResultHeaderID = "searchViewHeaderID"
    
    var sections = ["Technician's Ranking", "Nearby Technicians"]
    
    var userPostModel = [PostModel]()
    var technicianModel = [TechnicianModel]()
    var technieRank = [TechnicianModel]()

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
    
    lazy var refresher: UIRefreshControl = {
        let rc = UIRefreshControl()
//        rc.isEnabled = false
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    lazy var clientFeedCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 5
//        collectionLayout.sectionHeadersPinToVisibleBounds = true

        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear 
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.refreshControl = refresher
        cv.delegate = self
        cv.dataSource = self
        //        cv.collectionViewLayout.invalidateLayout()
        cv.isHidden = true
        // Registration of the cells
        cv.register(NearbyTechniesCell.self, forCellWithReuseIdentifier: feedCellOnSection1ID)
        cv.register(TechnieRankingCell.self, forCellWithReuseIdentifier: feedCellOnSection2ID)
        // header
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        return cv
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
        //        cv.contentInsetAdjustmentBehavior = .never
        
        cv.delegate = self
        cv.dataSource = self
        //        cv.collectionViewLayout.invalidateLayout()
        // Registration of the cell
        cv.register(SearchResultCell.self, forCellWithReuseIdentifier: searchResultCellID)
        // header
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        return cv
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
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        
        // Setup SearchBar
        let searchBar = search.searchBar
        searchBar.placeholder = "Search for technicians (ex: name, profession)"
        searchBar.sizeToFit()
        searchBar.delegate = self
        // changes searchbar placeholder appearance
        let placeholderAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        placeholderAppearance.font = .systemFont(ofSize: 15)
        return search
    }()
    
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

    lazy var warningLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Our service is offline, please try again later."
        return lbl
    }()
    
    private var indicator: ProgressIndicatorLarge!
        
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
        
        if technicianModel.count == 0 {
            indicator.start()
        }
        
        fetchUserPosts()
        fetchData()
        setupViews()
        print("viewDidLoadFeed: \(didShowSearchResultViewObservable.value)")
//        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
//        print("persistUsersInfo: \(getUsersPersistedInfo)")
        
//        UserDefaults.standard.removeObject(forKey: "persistUsersInfo")
//        DatabaseManager.shared.getAllClientPosts(completion: { result in
//            switch result {
//            case .success(let userPosts):
//                print("userPost: \(userPosts), count: \(userPosts.count)")
//            case .failure(let error):
//                print(error)
//            }
//        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listenToPostsChange()
    }
    
    fileprivate func collectionViewFlowLayoutSetup(with Width: CGFloat){
        if let flowLayout = clientFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: Width, height: 300)
        }
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        [clientFeedCollectionView, searchResultView, indicator].forEach {view.addSubview($0)}
        
        clientFeedCollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        
        searchResultView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: navBarHeight , left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setupNavBar(){
//        ProgressHUD.colorAnimation = .systemBlue
//        ProgressHUD.colorProgress = .systemBlue
//        ProgressHUD.animationType = .circleStrokeSpin
//        ProgressHUD.show("Posting...", interaction: false)

        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Feeds"
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        // Left navigation bar item
        //        let leftBarItemUserProfile = UIBarButtonItem(image: wiredProfileImage, style: .plain, target: self, action: #selector(leftBarItemPressed))
        //        let customBarItem = UIBarButtonItem(customView: userProfileNavBarBtn)
        //        navigationItem.leftBarButtonItem = leftBarItemUserProfile
        
        navigationItem.searchController = searchController
//        searchController.isActive = true
//        searchController.searchBar.becomeFirstResponder()
    }
    
    fileprivate func fetchData()  {
        view.isUserInteractionEnabled = false
        searchController.searchBar.isUserInteractionEnabled = false
        
        DatabaseManager.shared.getAllTechnicians(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let technicians):
                self.technicianModel.append(technicians)
                
                UIView.animate(withDuration: 0.5) {
                    self.indicator.stop()
//                    UIView.animate(withDuration: 0.5) {
//                        ProgressHUD.showSucceed()
//                    }
                   
                    self.indicator.removeFromSuperview()
                    self.clientFeedCollectionView.isHidden = false
                    self.view.isUserInteractionEnabled = true
                    self.searchController.searchBar.isUserInteractionEnabled = true
                    self.clientFeedCollectionView.reloadData()
                }
                
                let refreshDeadline = DispatchTime.now() + .milliseconds(100)
                DispatchQueue.main.asyncAfter(deadline: refreshDeadline) {
                    self.fetchRanking()
                }
             
            case .failure(let error):
                
                if self.technicianModel.count == 0 {
//                    self.clientFeedCollectionView.isHidden = true
                    self.view.addSubview(self.warningLabel)
                    NSLayoutConstraint.activate([
                        self.warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        self.warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    ])
                } else {
//                    self.clientFeedCollectionView.isHidden = false
                }
                
                self.indicator.stop()
                self.indicator.removeFromSuperview()
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func fetchUserPosts()  {
        DatabaseManager.shared.getAllClientPosts(completion: { [self] result in
            switch result {
            case .success(let userPosts):
                userPostModel = userPosts
            case .failure(let error):
                print(error)
            }
        })
    }
    
    fileprivate func listenToPostsChange() {
        DispatchQueue.main.async {
            DatabaseManager.shared.listenToClientPostChanges(completion: { result in
                switch result {
                case .success(let posts):
                    // Remove existing items to avoid duplicated items
                    self.userPostModel.removeAll()
                    print("childChanged")
//                    let sortedArray = posts.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateTime)?.compare(PostFormVC.dateFormatter.date(from: $1.dateTime) ?? Date()) == .orderedDescending })
                    self.userPostModel = posts
                    return
                case .failure(let error):
                    print("Failed to get posts: \(error.localizedDescription)")
                }
            })
        }
    }
    
    fileprivate func showSearchResultView() {
        
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [self] in
            didShowSearchResultViewObservable.value = true
            searchResultView.alpha = 1
            // Remove the collectionView from it's parentView to avoid clientFeedCollectionView ItemSize collapse with the searchResultCollectionView itemSize
            self.clientFeedCollectionView.removeFromSuperview()
        }, completion: nil)
    }
    
    fileprivate func hideSearchResultView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [self] in
            searchResultView.alpha = 0
            didShowSearchResultViewObservable.value = false
            
            /// Completion outside of the completion block to avoid delay
            // Remove the collectionViewFrom it's parentView for a better memory efficiency
            searchResultCollectionView.removeFromSuperview()
            // searchResultView is placed there to give the navigationBar its original collapse animation
            [clientFeedCollectionView, searchResultView].forEach {view.addSubview($0)}
            clientFeedCollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
            
        }, completion: nil)
        
    }
    
    fileprivate func fetchRanking() {
        DatabaseManager.shared.getTechnieRank { result in
            switch result {
            case .success(let technieRank):
                self.technieRank = technieRank
            case .failure(let error):
                self.removeSectionOne()
                print(error)
            }
        }
    }
    
    fileprivate func refreshTechniciansData() {
        self.technicianModel.removeAll()

        DatabaseManager.shared.getAllTechnicians(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let technicians):
                self.technicianModel.append(technicians)
                self.clientFeedCollectionView.reloadData()
//                self.refresher.endRefreshing()
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    
    }
    
    // MARK: - Selectors
    
    @objc func refreshData(_ refreshController: UIRefreshControl){
        DispatchQueue.main.async {
            self.refreshTechniciansData()
            let refreshDeadline = DispatchTime.now() + .seconds(Int(2))
            DispatchQueue.main.asyncAfter(deadline: refreshDeadline) {
                refreshController.endRefreshing()
            }
        }
    }
       
        
    
    @objc fileprivate func leftBarItemPressed(){
        let userProfileVC = UserProfileVC()
        //        userProfileVC.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    var filteredData: [TechnicianModel] = []
    let hasLaunchedKey = "HasLaunched"
    let defaults = UserDefaults.standard
   
    
}

// MARK: - UISearchBarDelegate Extension
extension ClientFeedVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSearchResultView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchResultView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.autocapitalizationType = .none
        guard let searchedString = searchBar.text else { return }
        presentSearchResults(searchedString, filteredData)
    }
//    func presentSearchController(_ searchController: UISearchController) {
//        searchController.searchBar.becomeFirstResponder()
//    }
    
    fileprivate func presentSearchResults(_ searchedString: String,_ filteredTechnicians: [TechnicianModel]) {
        let vc = TechnicianSearchResultsVC()
        vc.title = "\(searchedString) results".lowercased()
        vc.technicianModel = filteredTechnicians
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        searchBar.text = searchText.lowercased()
        if searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            //            print("isEmpty")
        } else {
        }
        
        if searchText.isEmpty == false {
//            let skills = technicianModel.profileInfo.skills
//            let flatStrings = skills.joined(separator: ", ")
            if searchText != "," {
                guard !searchText.replacingOccurrences(of: " ", with: "").isEmpty else { return }
                filteredData = technicianModel
                let filteredArray = technicianModel.filter { (technician) -> Bool in
                    return technician.profileInfo.name.localizedCaseInsensitiveContains(searchText) || technician.profileInfo.skills.joined(separator: ", ").localizedCaseInsensitiveContains(searchText) }
                filteredData = filteredArray//technicianModel.filter({ $0.profileInfo.skills.joined(separator: ", ").localizedCaseInsensitiveContains(searchText) })
                print(filteredArray)
            }
          
           
//            isSearching = true
//            collectionView.reloadData()
        }
       
    }
    
   
    func removeSectionOne() {
//        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
//
//            if !hasLaunched {
//                defaults.set(true, forKey: hasLaunchedKey)
//            }
//        sections.remove(at: 0)
//        clientFeedCollectionView.deleteSections(IndexSet(integer: 0))
//        clientFeedCollectionView.reloadSections(IndexSet(integer: 0))
        // At this point the collection view will ask again for the number of sections and it will be updated
    }
}

// MARK: - CollectionViewDelegateAndDataSource Extension
extension ClientFeedVC: CollectionDataSourceAndDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return didShowSearchResultViewObservable.value == true ? (1) : (sections.count) //sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return didShowSearchResultViewObservable.value == true ? (professionArray.count) : (section == 0 ? (1) : (technicianModel.count)) //section == 0 ? (1) : (5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // this cell is only showed when this condition is true
        if didShowSearchResultViewObservable.value == true && indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchResultCellID, for: indexPath) as! SearchResultCell
            cell.backgroundColor = .systemGray4
            cell.title.text = professionArray[indexPath.item]
            cell.dynamicWidth.constant = cell.frame.width
            return cell
        }
        
        if sections.count == 1 {
            // Nearby Technie cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellOnSection1ID, for: indexPath) as! NearbyTechniesCell
            let model = technicianModel[indexPath.item]
            cell.technicianModel = model
//            let lastItemIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections-1)

            return cell
        } else {
            switch indexPath.section {
            case 0:
                // Technie Ranking cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellOnSection2ID, for: indexPath) as! TechnieRankingCell
                cell.userPostModel = userPostModel
                return cell
                
            case 1:
                // Nearby Technie cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellOnSection1ID, for: indexPath) as! NearbyTechniesCell
                let model = technicianModel[indexPath.item]
                cell.technicianModel = model
//                let lastItemIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections-1)
    //            let lastIndex = lastItemIndex - 1
    //            if indexPath.item == lastIndex {
    //                cell.separatorView.isHidden = true
    //            }
                return cell
            default:
                break
            }
        }
        
      
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch didShowSearchResultViewObservable.value {
        case true:
            print("resultView Showing now")
            let profession = professionArray[indexPath.item]
            let filteredByProfession = profession == "Others" ? (technicianModel) : (technicianModel.filter({ $0.profileInfo.skills.joined(separator: ", ").contains(profession)}))
            
            let vc = TechnicianSearchResultsVC()
            vc.title = "\(professionArray[indexPath.item]) technician results".lowercased()
            vc.technicianModel = filteredByProfession

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: nil)
            navigationController?.pushViewController(vc, animated: true)
        case false:
            let technicians = technicianModel[indexPath.item]
            
            let vc = TechnicianProfileDetailsVC()
            vc.technicianModel = technicians
            vc.userPostModel = userPostModel
            vc.profileImageView.sd_setImage(with: URL(string: technicians.profileInfo.profileImage ?? ""))
            vc.nameLabel.text = technicians.profileInfo.name
            vc.locationLabel.text = technicians.profileInfo.location?.address ?? ""
            var yearLabel = ""
            let convertedYear = Int(technicians.profileInfo.experience)
            convertedYear == 1 ? (yearLabel = "Year") : (yearLabel = "Years")
            vc.technicianExperienceLabel.text = "• \(technicians.profileInfo.experience) \(yearLabel) of Exp."
            
            let delimiter = "at"
            let slicedString = technicians.profileInfo.membershipDate.components(separatedBy: delimiter)[0]
            vc.memberShipDateLabel.text = "• Member since " + slicedString
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Feeds", style: .plain, target: self, action: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        
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
        
        let viewSize = view.frame.size
        var collectionViewSize = CGSize(width: 0, height: 0)
        
        if didShowSearchResultViewObservable.value == true {
            switch indexPath.section {
            case 0:
                //                if indexPath.item == 0 {
                //                    collectionViewSize = CGSize(width: viewSize.width, height: 250)
                //                    return collectionViewSize
                //                }
                return finalSize
            case 1:
                collectionViewSize = CGSize(width: viewSize.width, height: 150)
                return collectionViewSize
            default:
                break
            }
            
        } else {
            
            switch indexPath.section {
            case 0:
                let screenSize = UIScreen.main.bounds
                collectionViewSize = CGSize(width: viewSize.width, height: screenSize.width/1.72)
                return collectionViewSize
            case 1:
                collectionViewSize = CGSize(width: viewSize.width - 10, height: 150)
                return collectionViewSize
            default:
                break
            }
        }
        
        return CGSize.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Section 0 EdgeInsets
        var collectionViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if didShowSearchResultViewObservable.value == true {
            collectionViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            return collectionViewEdgeInsets
        }
        
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
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! HeaderView
        
        if didShowSearchResultViewObservable.value == true {
            header.sectionTitle.text = "Search by category".uppercased()
//            header.backgroundColor = .systemBackground
//            header.sectionTitle.backgroundColor = .brown
//            header.stackView.addBackground(color: .cyan)
            header.headerDynamicLeadingAnchor.constant = 0
            return header
        }
        
        if sections.count == 1 {
            header.sectionTitle.text = sections[indexPath.section].uppercased()
            header.backgroundColor = .systemBackground
            header.addBorder(.bottom, color: .systemGray, thickness: 0.3)
            header.seeAllBtn.isHidden = true
        } else {
            switch indexPath.section {
            case 0:
                header.rank = technieRank
    //            header.postModel = userPostModel
                header.sectionTitle.text = sections[indexPath.section].uppercased()
                //            header.backgroundColor = .red
                // Show seeAllBtn only for this section
                header.seeAllBtn.isHidden = false
                header.backgroundColor = .systemBackground
                //            header.sectionTitle.backgroundColor = .brown
                header.addBorder(.bottom, color: .systemGray, thickness: 0.3)
                return header
            case 1:
                header.sectionTitle.text = sections[indexPath.section].uppercased()
                header.backgroundColor = .systemBackground
                header.addBorder(.bottom, color: .systemGray, thickness: 0.3)
                header.seeAllBtn.isHidden = true
                return header
            default:
                break
            }
        }
       
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if didShowSearchResultViewObservable.value == true {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    fileprivate func configureCollectionViewLayout(_ isActive: Bool) {
        if let layout = self.clientFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 16
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            layout.sectionHeadersPinToVisibleBounds = isActive
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handles to stick only the header on the section 1
        guard let layout = clientFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let offsetY = scrollView.contentOffset.y
//        print("offsetY: \(offsetY)")
        layout.sectionHeadersPinToVisibleBounds = offsetY > 156.0
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
