//
//  TechnicianProfileDetailsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/3/21.
//

import UIKit

class TechnicianProfileDetailsVC: UIViewController, CustomSegmentedControlDelegate, UIScrollViewDelegate {

    var technicianModel: TechnicianModel!
    var userPostModel = [PostModel]()
    var tempUserPosts = [PostModel]()

    var satisfactionAvrg: ClientsSatisfaction?
    var reviews = [Review]()
    
    // MARK: - Properties
    lazy var profileImageView: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        iv.roundedImage()
        iv.image = UIImage(named: "technieDummyPhoto")//?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        //        iv.sizeToFit()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter A. Machado"
        lbl.font = .boldSystemFont(ofSize: 16)
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
        lbl.textAlignment = .left
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 12.5)
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
//        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    var currentSegmentIndex = 0

    lazy var customSegmentedControl: CustomSegmentedControl = {
        let segment = CustomSegmentedControl()
        segment.setButtonTitles(buttonTitles: ["ABOUT", "REVIEWS"])
        segment.selectorViewColor = .systemPink
        segment.selectorTextColor = .systemPink
        segment.backgroundColor = .clear
        segment.delegate = self
        return segment
    }()
    
    lazy var switchableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var switchableViews = [UIView]()
    
    var aboutSectionSetter = [SectionHandler]()
    var reviewsSectionSetter = [SectionHandler]()

    lazy var aboutTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.clipsToBounds = true
        tv.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(AboutCell.self, forCellReuseIdentifier: AboutCell.cellID)
        return tv
    }()
    
    lazy var reviewsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.clipsToBounds = true
//        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ReviewsCell.self, forCellReuseIdentifier: ReviewsCell.cellID)
        tv.register(ProficiencyReviewCell.self, forCellReuseIdentifier: ProficiencyReviewCell.cellID)
        return tv
    }()
    
    lazy var hireBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let delimiter = " "
        let technicianFirstName = technicianModel.profileInfo.name.components(separatedBy: delimiter)[0]
        
        btn.setTitle("Hire \(technicianFirstName.uppercased())", for: .normal)
//        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemPink
//        btn.contentHorizontalAlignment = .left
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
//        btn.withWidth(180)
        btn.titleLabel?.font = .systemFont(ofSize: 13.5)
        btn.addTarget(self, action: #selector(hireBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("Chat Me", for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .small)

        btn.setImage(UIImage(systemName: "ellipsis.circle.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal), for: .normal)
        btn.contentHorizontalAlignment = .right
//        btn.backgroundColor = .cyan
        // rotates btn 90 degrees for a vertical look of the icon
        btn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        btn.withWidth(30)
        btn.withHeight(30)
        btn.addTarget(self, action: #selector(moreBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var hireAndStartAChatBtnStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hireBtn, moreBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillProportionally
//        stack.withWidth(view.frame.width - 100)
//        stack.withHeight(30)
//        stack.backgroundColor = .blue
        return stack
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.contentView.addBorder(.top, color: .systemGray2, thickness: 0.2)
        return view
    }()
    
    lazy var rankingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "• Technie Rank: 1/5000"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var technicianAgeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "• 30 years old"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var technicianExperienceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "• 8 Year of Exp."
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var memberShipDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "• Member since October'13"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var technicianInfoLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, locationWithIconStackView, technicianExperienceLabel, memberShipDateLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = -15
        sv.alignment = .leading
        sv.distribution = .fillEqually
//        sv.addBackground(color: .brown)
        return sv
    }()
    
    lazy var technicianInfoMainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImageView, technicianInfoLabelStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 20
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .brown)
        return sv
    }()
    
    lazy var locationWithIconStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .small)
        var wiredProfileImage = UIImage(systemName: "mappin.and.ellipse", withConfiguration: config)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.withWidth(13)
//        iconIV.backgroundColor = .brown
        iconIV.image = wiredProfileImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let sv = UIStackView(arrangedSubviews: [iconIV, locationLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
        sv.withWidth(view.frame.width - 140)
        return sv
    }()
    
    var isSearching = false
    
    lazy var titleView: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.backgroundColor = .red
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.text = nameLabel.text
        lbl.isHidden = true
        return lbl
    }()
    
    
    override func loadView() {
        super.loadView()
    }
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        currentSegmentIndex = 0
        
        getClientSatisfaction()
        setupViews()
        setupSwitchableContainerView()
        populateSections()
        fetchUserPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        
        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
        closeSelectionBar()
        self.reviewsTableView.removeObserver(self, forKeyPath: "contentSize")
        self.aboutTableView.removeObserver(self, forKeyPath: "contentSize2")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
            self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
            presentSelectionBar()
            self.reviewsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            self.aboutTableView.addObserver(self, forKeyPath: "contentSize2", options: .new, context: nil)
    }
    
    var reviewDynamicHeight: CGFloat = 0.0
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if currentSegmentIndex  == 0 || currentSegmentIndex  == 1 {
            if(keyPath == "contentSize"){
                
                if let newvalue = change?[.newKey]{
                    let newsize  = newvalue as! CGSize
                    reviewDynamicHeight = newsize.height

                    reviewsTableView.heightConstraint?.constant = 0
                    reviewsTableView.heightConstraint?.constant = newsize.height
                    collectionView.layoutIfNeeded()
                }
            }
            
            if(keyPath == "contentSize2"){
                
                if let newvalue = change?[.newKey]{
                    let newsize  = newvalue as! CGSize
                    aboutTableView.heightConstraint?.constant = 0
                    aboutTableView.heightConstraint?.constant = newsize.height
                    collectionView.layoutIfNeeded()
                }
            }
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        if isSearching == true {
            navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = titleView
    }

    var hiredUserJobs = [PostModel]()
    var jobTrack = ""
    var jobPending = ""
    var sureHires = [Bool]()
    
    fileprivate func fetchUserPosts() {
        for post in userPostModel {
            if post.isCompleted != true {
                if technicianModel.profileInfo.email != post.hiringStatus?.technicianToHireEmail && post.hiringStatus?.isHired == false  {
                    tempUserPosts.append(post)
                    print("first loop")
                } else if userPostModel.count == 1 && technicianModel.profileInfo.email == post.hiringStatus?.technicianToHireEmail {
                    UIView.animate(withDuration: 0.5) { [self] in
                        post.hiringStatus?.isHired == false ? hireBtn.setTitle("Pending...", for: .normal) : hireBtn.setTitle("Hired", for: .normal)
                        hireBtn.setTitleColor(.systemGray4, for: .normal)
                        hireBtn.backgroundColor = UIColor.systemPink.withAlphaComponent(0.8)
                    }
                    print("second loop")
                } else if userPostModel.count > 1 && technicianModel.profileInfo.email == post.hiringStatus?.technicianToHireEmail {
                    hiredUserJobs.append(post)
                    sureHires.append(post.hiringStatus!.isHired)
                    
                    UIView.animate(withDuration: 0.5) { [self] in
                        let numberOfTrue = sureHires.filter{$0}.count
                        let numberOfFalse = sureHires.filter{!$0}.count
                        
                        numberOfTrue == 1 ? (jobTrack = "one") : (jobTrack = "\(numberOfTrue)")
                        numberOfFalse == 1 ? (jobPending = "one") : (jobPending = "\(numberOfFalse)")
                        
                        numberOfFalse == 0 ? hireBtn.setTitle("Currently hired in \(jobTrack) of my jobs", for: .normal) : hireBtn.setTitle("Currently hired with \(jobPending) offer pending...", for: .normal)
                        hireBtn.setTitleColor(.systemGray4, for: .normal)
                        hireBtn.backgroundColor = UIColor.systemPink.withAlphaComponent(0.8)
                    }
                    print("third loop")
                } else {
                    print("last loop")
                    tempUserPosts.append(post)
                }
            }
//            else if technicianModel.profileInfo.email == post.hiringStatus?.technicianToHireEmail {
//                print("technicianToHireEmail")
//            }
        }
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
    
    func getClientSatisfaction() {
        guard let model = technicianModel else { return }
        let technicianKeyPath = model.profileInfo.id 

        DatabaseManager.shared.getAllClientSatisfactionWithReviews(with: technicianKeyPath) { result in
            
            switch result {
            case .success(let satisfactionAvrg):
                self.satisfactionAvrg = satisfactionAvrg
                self.reviewsTableView.reloadData()
                print(satisfactionAvrg)
            case .failure(let error):
                print(error)
            }
        } onReviewCompletion: { result in
            
            switch result {
            case .success(let reviews):
                let sortedArray = reviews.sorted(by: { PostFormVC.dateFormatter.date(from: $0.dateOfReview)?.compare(PostFormVC.dateFormatter.date(from: $1.dateOfReview) ?? Date()) == .orderedDescending })
                self.reviews = sortedArray
                
                self.reviewsTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func presentSelectionBar() {
        let screenSize = UIScreen.main.bounds.size
        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        let tabHeight = tabBarController?.tabBar.frame.height ?? navBarHeight*1.5
        // window
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        // visualEffectView
        visualEffectView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: tabHeight)
        window.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(hireAndStartAChatBtnStack)
        NSLayoutConstraint.activate([
            hireAndStartAChatBtnStack.topAnchor.constraint(equalTo: visualEffectView.contentView.topAnchor, constant: 15),
            hireAndStartAChatBtnStack.centerXAnchor.constraint(equalTo: visualEffectView.contentView.centerXAnchor),
            hireAndStartAChatBtnStack.widthAnchor.constraint(equalToConstant: view.frame.width - 80),
            hireAndStartAChatBtnStack.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }

            self.visualEffectView.frame = CGRect(x: 0, y: screenSize.height - tabHeight, width: screenSize.width, height: tabHeight)
            
            self.visualEffectView.isHidden = false
            self.hireAndStartAChatBtnStack.isHidden = false
            self.hireAndStartAChatBtnStack.fadeIn()
        }, completion: nil)
    }
    
    fileprivate func closeSelectionBar() {
        self.hireAndStartAChatBtnStack.isHidden = true
        self.visualEffectView.isHidden = true
        
        let screenSize = UIScreen.main.bounds.size
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }

            self.hireAndStartAChatBtnStack.frame = CGRect(x: 0, y: (screenSize.height - tabHeight)/0.9, width: screenSize.width , height: 0.35)
            self.visualEffectView.frame = CGRect(x: 0, y: (screenSize.height - tabHeight)/0.9, width: screenSize.width, height: tabHeight)
            self.hireAndStartAChatBtnStack.fadeOut()
            
        }) { (_) in
            self.hireAndStartAChatBtnStack.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    fileprivate func populateSections() {
        
        aboutSectionSetter.append(SectionHandler(title: "Summary", detail: [technicianModel.profileInfo.profileSummary]))
        aboutSectionSetter.append(SectionHandler(title: "Expertise", detail: technicianModel.profileInfo.skills))
        aboutSectionSetter.append(SectionHandler(title: "Legitimacy", detail: ["Proof of Expertise"]))

        reviewsSectionSetter.append(SectionHandler(title: "Proficience", detail: [""]))
        reviewsSectionSetter.append(SectionHandler(title: "Reliability", detail: [""]))
        reviewsSectionSetter.append(SectionHandler(title: "Reviews", detail: ["Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews", "Reviews"]))
    }
    
    let customReviewView = UIView()
    let customAboutView = UIView()

    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
//        collectionLayout.minimumLineSpacing = 5
        collectionLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cv.delegate = self
        cv.dataSource = self
        //        cv.collectionViewLayout.invalidateLayout()
        
        // Registration of the cells
        cv.register(ReviewCollectionViewTopCell.self, forCellWithReuseIdentifier: ReviewCollectionViewTopCell.cellID)
        cv.register(ReviewCollectionViewBottomCell.self, forCellWithReuseIdentifier: ReviewCollectionViewBottomCell.cellID)
        // header
        cv.register(ReviewCollectionViewCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewCollectionViewCellHeaderView.cellID)
        
        return cv
    }()
    
    fileprivate func setupSwitchableContainerView() {
        // Add the VCs containterView to the switchableViews array
        switchableViews.append(AboutVC().view)
        switchableViews.append(ReviewsVC().view)
        
        // removeFromSuperview the view that is not being displayed for a better memory efficiency
        switchableContainerView.addSubview(switchableViews[0])
        switchableViews[0].frame = switchableContainerView.bounds
        switchableViews[0].addSubview(aboutTableView)
        aboutTableView.anchor(top: switchableViews[0].topAnchor,
                         leading: switchableViews[0].leadingAnchor,
                         bottom: nil,
                         trailing: switchableViews[0].trailingAnchor)
        aboutTableView.heightAnchor.constraint(equalToConstant: view.frame.height + visualEffectView.frame.height).isActive = true
        
        switchableViews[1].fadeOut()
        // Using timer to avoid unsmooth fade animation caused by the same view that is being faded then later on removeFromSuperview
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) { [self] in
            DispatchQueue.main.async {
                switchableViews[1].removeFromSuperview()
            }
        }
    }
    
    func change(to index: Int) {
        // Return if currentSegmentIndex is the same with the segmentedControlIndex
        if currentSegmentIndex == index { return }
        currentSegmentIndex = index
        print("segmentedControl index changed to \(index)")
        
        switchableViews[index].fadeOut()
        switchableContainerView.addSubview(switchableViews[index])
        switchableViews[index].frame = switchableContainerView.bounds
        switchableViews[index].fadeIn()
        
        switch currentSegmentIndex {
        case 0:
            
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            if layout.sectionHeadersPinToVisibleBounds == true {
                // Scrolls the content to the 125 offsetY
                collectionView.setContentOffset(CGPoint(x: 0.0, y: 125), animated: true)
            }
            
        case 1:
            if reviews.count == 0 {
                let noReviewsView = UIView()
                noReviewsView.backgroundColor = .systemBackground
                switchableViews[currentSegmentIndex].addSubview(noReviewsView)
                noReviewsView.frame = switchableViews[currentSegmentIndex].bounds
                switchableViews[currentSegmentIndex].layoutIfNeeded()
                
                let noReviewLabel = UILabel()
                noReviewLabel.translatesAutoresizingMaskIntoConstraints = false
                noReviewLabel.numberOfLines = 0
                noReviewLabel.text = "This technican has no reviews yet"
                noReviewLabel.textAlignment = .center
                noReviewsView.addSubview(noReviewLabel)
                NSLayoutConstraint.activate([
                    noReviewLabel.topAnchor.constraint(equalTo: noReviewsView.topAnchor, constant: 50),
                    noReviewLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                ])
            } else {
                switchableViews[currentSegmentIndex].addSubview(reviewsTableView)
                reviewsTableView.anchor(top: switchableViews[currentSegmentIndex].topAnchor,
                                        leading: switchableViews[currentSegmentIndex].leadingAnchor,
                                        bottom: nil,
                                        trailing: switchableViews[currentSegmentIndex].trailingAnchor,
                                        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                reviewsTableView.heightAnchor.constraint(equalToConstant: reviewDynamicHeight == 0.0 ? (collectionView.frame.height) : (reviewDynamicHeight)).isActive = true
            }
        default:
            break
        }
        switchableViews[index == 1 ? (0) : (1)].fadeOut()
        // Using timer to avoid unsmooth fade animation caused by the same view that is being faded then later on removeFromSuperview
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) { [self] in
            DispatchQueue.main.async {
                switchableViews[index == 1 ? (0) : (1)].removeFromSuperview()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let offsetY = scrollView.contentOffset.y
        // Handles to stick only the header on the section 1
        layout.sectionHeadersPinToVisibleBounds = offsetY > 125.0
        
        // Fades in and out the titleView based on the offsetY
        if offsetY >= 25.0 {
            titleView.isHidden = !(titleView.alpha > 0.001)
        }
        let alpha: CGFloat = (offsetY-25)/100
        titleView.alpha = alpha
//        print("offsetY: \(offsetY)")
//        print("alpha: \(alpha)")
    }
    
    
    // MARK: - Selectors
    @objc fileprivate func hireBtnPressed(_ sender: UIButton) {
        let delimiter = " "
        let technicianFirstName = technicianModel.profileInfo.name.components(separatedBy: delimiter)[0]
        
        switch sender.title(for: .normal) {
        case "Hire \(technicianFirstName.uppercased())":
            let vc = MyJobsVC()
            vc.myJobsVCDismissalDelegate = self
            vc.technicianModel = technicianModel
            vc.userPostModel = tempUserPosts
            present(UINavigationController(rootViewController: vc), animated: true)
            
        case "Pending...":
//            presentAlertSheetForHireBtn()
            print("pending")
        case "Hired":
//            presentAlertSheetForHireBtn()
            print("Hired")
        case "Currently hired in \(jobTrack) of my jobs":
            presentActionSheetForHireBtn()
            
        case "Currently hired with \(jobPending) offer pending...":
            presentActionSheetForHireBtn()
        default:
            break
        }
        
    }
    
    fileprivate func presentAlertSheetForHireBtn() {
        let delimiter = " "
        let technicianFirstName = technicianModel.profileInfo.name.components(separatedBy: delimiter)[0]
        
        let alertController = UIAlertController(title: "Hiring", message: "Are you sure you want to pullback from this hire?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            UIView.animate(withDuration: 0.5) { [self] in
                hireBtn.setTitle("Hire \(technicianFirstName.uppercased())", for: .normal)
                hireBtn.setTitleColor(.white, for: .normal)
                hireBtn.backgroundColor = .systemPink
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    fileprivate func presentActionSheetForMoreBtn() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let inviteAction = UIAlertAction(title: "Send Invitation", style: .default) { [self] (_) in
            let vc = MyJobsVC()
            vc.myJobsVCDismissalDelegate = self
            vc.technicianModel = technicianModel
            vc.userPostModel = tempUserPosts
            vc.isSendingInvitation = true
            present(UINavigationController(rootViewController: vc), animated: true)
        }
        
        let dmAction = UIAlertAction(title: "Direct Message", style: .default) { [self] (_) in
            self.createNewConversation(resultEmail: technicianModel.profileInfo.email,
                                       resultName: technicianModel.profileInfo.name)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(inviteAction)
        alertController.addAction(dmAction)
        alertController.addAction(cancelAction)
        alertController.fixActionSheetConstraintsError()
        present(alertController, animated: true)
    }
    
    fileprivate func presentActionSheetForHireBtn() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let declineAction = UIAlertAction(title: "Decline Hiring", style: .default) { [self] (_) in
            if hiredUserJobs.count != 1 {
                let vc = MyJobsVC()
                vc.myJobsVCDismissalDelegate = self
                vc.userPostModel = hiredUserJobs
                vc.technicianModel = technicianModel
                vc.isSentByDeclineAction = true
                present(UINavigationController(rootViewController: vc), animated: true)
            } else {
                presentAlertSheetForHireBtn()
            }
            
        }
        
        let viewAction = UIAlertAction(title: "View Jobs", style: .default) { [self] (_) in
            let vc = MyJobsVC()
            vc.myJobsVCDismissalDelegate = self
            vc.userPostModel = userPostModel
            vc.technicianModel = technicianModel
            vc.isSentByDeclineAction = false
            present(UINavigationController(rootViewController: vc), animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(declineAction)
        alertController.addAction(viewAction)
        alertController.addAction(cancelAction)
        alertController.fixActionSheetConstraintsError()
        present(alertController, animated: true)
    }
    
    @objc fileprivate func moreBtnPressed(_ sender: UIButton) {
        presentActionSheetForMoreBtn()
    }
    
    private func createNewConversation(resultEmail: String, resultName: String) {
        let name = resultName
        let email = DatabaseManager.safeEmail(emailAddress: resultEmail)

        // check in database if conversation with these two users exists
        // if it does, reuse conversation id
        // otherwise use existing code

        DatabaseManager.shared.conversationExists(with: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let convoId):
                print("success")
                let vc = ChatVC(with: email, id: convoId)
                vc.isNewConvo = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.present(UINavigationController(rootViewController: vc), animated: true)
            case .failure(let failure):
                print("failure: \(failure)")
                let vc = ChatVC(with: email, id: nil)
                vc.isNewConvo = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.present(UINavigationController(rootViewController: vc), animated: true)
            }
        })
    }
    
}

extension TechnicianProfileDetailsVC: MyJobsVCDismissalDelegate {
    // Handles the hire button label changes when the hiring was sent successfully
    func jobsVCDismissalSingleton(isDismissed withIsDone: Bool) {
        if withIsDone == true {
            UIView.animate(withDuration: 0.5) { [self] in
                hireBtn.setTitle("Pending...", for: .normal)
                hireBtn.setTitleColor(.systemGray4, for: .normal)
                hireBtn.backgroundColor = UIColor.systemPink.withAlphaComponent(0.8)
                listenToPostsChange()
            }
        }
    }
    
    
}

extension TechnicianProfileDetailsVC: CollectionDataSourceAndDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? (1) : (1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewTopCell.cellID, for: indexPath) as! ReviewCollectionViewTopCell
            
            [technicianInfoMainStackView].forEach{cell.customView.addSubview($0)}
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            technicianInfoMainStackView.anchor(top: cell.customView.topAnchor, leading: cell.customView.leadingAnchor, bottom: cell.customView.bottomAnchor, trailing: cell.customView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 0), size: CGSize(width: 0, height: 0))
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewBottomCell.cellID, for: indexPath) as! ReviewCollectionViewBottomCell
            [switchableContainerView].forEach{cell.contentView.addSubview($0)}
            switchableContainerView.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
//            switchableContainerView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            return cell
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 115)
        }
        
//        let navBarHeight = navigationController?.navigationBar.frame.height
//        let height = navBarHeight!*1.5
//        let adjustedHeight: CGFloat = (view.frame.height) + reviewsTableView.contentSize.height + visualEffectView.frame.height
        switch currentSegmentIndex {
        case 0:
            return CGSize(width:  collectionView.frame.size.width , height: view.frame.height - visualEffectView.frame.height*1.2)
        case 1:
            return CGSize(width:  collectionView.frame.size.width , height: reviewsTableView.contentSize.height + visualEffectView.frame.height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                            String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: ReviewCollectionViewCellHeaderView.cellID,
                                                                     for: indexPath) as! ReviewCollectionViewCellHeaderView
        
        header.backgroundColor = .systemBackground
        if indexPath.section == 1 {
            [customSegmentedControl].forEach{header.contentView.addSubview($0)}
            customSegmentedControl.anchor(top: header.contentView.topAnchor,
                                          leading: header.contentView.leadingAnchor,
                                          bottom: header.contentView.bottomAnchor,
                                          trailing: header.contentView.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                          size: CGSize(width: 0, height: 0))
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 25)
        }
        return CGSize(width: collectionView.frame.width, height: 10)
    }
}


// MARK: - TableViewDelegateAndDataSource Extension
extension TechnicianProfileDetailsVC: TableViewDataSourceAndDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentSegmentIndex {
        case 0:
            return aboutSectionSetter.count
        case 1:
            return 3
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSegmentIndex {
        case 0:
            return aboutSectionSetter[section].sectionDetail.count
        case 1:
            if section > 1 {
                return reviews.count
            }
            return 1
        default:
            return aboutSectionSetter[section].sectionDetail.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch currentSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.cellID, for: indexPath) as! AboutCell
            let detailText = aboutSectionSetter[indexPath.section].sectionDetail[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = detailText
            if indexPath.section == 2 {
                cell.selectionStyle = .default
                cell.accessoryType = .detailDisclosureButton
            }
            return cell
        case 1:

//            let detailText = reviewsSectionSetter[indexPath.section].sectionDetail[indexPath.row]

            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProficiencyReviewCell.cellID, for: indexPath) as! ProficiencyReviewCell
                cell.setupViews()
                cell.satisfactionAvrg = satisfactionAvrg
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProficiencyReviewCell.cellID, for: indexPath) as! ProficiencyReviewCell
                cell.setupReliabilityStackView()
                
                let numberOfServices = technicianModel.numberOfServices
                var serviceText = ""
                numberOfServices == 1 ? (serviceText = "Service") : (serviceText = "Services")
                cell.ratingAndReviewsLabel.text = " \(String(format:"%.1f", satisfactionAvrg!.ratingAvrg)) | \(numberOfServices) " + serviceText
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell.cellID, for: indexPath) as! ReviewsCell
                cell.setupViews()
                cell.reviews = reviews[indexPath.row]
                return cell
            default:
                return UITableViewCell()
            }

        default:
            return UITableViewCell()
        }

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch currentSegmentIndex {
        case 0:
            return aboutSectionSetter[section].sectionTitle
        case 1:
            if section <= 1 {
                return nil
            }
            return reviewsSectionSetter[section].sectionTitle! + " (\(reviews.count))"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentSegmentIndex {
        case 0:
            if indexPath.section == 2 {
                tableView.deselectRow(at: indexPath, animated: true)
                let vc = ProofOfExpertiseVC()
                vc.proofOfExpertiseUrl = technicianModel.profileInfo.proofOfExpertise
                present(UINavigationController(rootViewController: vc), animated: true)
            }
        case 1:
            print("case 1")
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if indexPath.section == 2 {
            presentProofOfExprtiseAlert()
        }
    }
    
    func presentProofOfExprtiseAlert() {
        let alertController = UIAlertController(title: nil, message: "Proof of authentication of the provider services.", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
      
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
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
