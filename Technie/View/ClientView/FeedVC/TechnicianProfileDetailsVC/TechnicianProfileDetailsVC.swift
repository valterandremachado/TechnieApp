//
//  TechnicianProfileDetailsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/3/21.
//

import UIKit

class TechnicianProfileDetailsVC: UIViewController, CustomSegmentedControlDelegate, UIScrollViewDelegate {

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
//        iv.backgroundColor = .red
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
        btn.setTitle("Hire Valter", for: .normal)
//        btn.setTitleColor(.white, for: .normal)

//        btn.contentHorizontalAlignment = .left
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.backgroundColor = .cyan
//        btn.withWidth(180)
        btn.addTarget(self, action: #selector(hireBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var startAChatBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("Chat Me", for: .normal)
        btn.setImage(UIImage(systemName: "bubble.left.and.bubble.right.fill"), for: .normal)
        btn.contentHorizontalAlignment = .right
//        btn.backgroundColor = .cyan
        btn.withWidth(45)
        return btn
    }()
    
    lazy var hireAndStartAChatBtnStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hireBtn, startAChatBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
//        stack.withWidth(view.frame.width - 100)
//        stack.withHeight(30)
        return stack
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
    
    override func loadView() {
        super.loadView()
    }
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        currentSegmentIndex = 0
        setupViews()
        setupSwitchableContainerView()
        populateSections()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
        closeSelectionBar()
        self.reviewsTableView.removeObserver(self, forKeyPath: "contentSize")
        self.aboutTableView.removeObserver(self, forKeyPath: "contentSize2")
//        self.collectionView.removeObserver(self, forKeyPath: "contentSize3")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
        presentSelectionBar()
        self.reviewsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.aboutTableView.addObserver(self, forKeyPath: "contentSize2", options: .new, context: nil)
//        self.collectionView.addObserver(self, forKeyPath: "contentSize3", options: .new, context: nil)

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
                    //                switchableContainerView.heightConstraint?.constant = newsize.height
//                    switchableContainerView.layoutIfNeeded()
//                    reviewsTableView.layoutIfNeeded()
                    collectionView.layoutIfNeeded()
//                    collectionView.reloadData()
//                    view.layoutIfNeeded()
                }
            }
            
            if(keyPath == "contentSize2"){
                
                if let newvalue = change?[.newKey]{
                    let newsize  = newvalue as! CGSize
                    aboutTableView.heightConstraint?.constant = 0
                    aboutTableView.heightConstraint?.constant = newsize.height
//                    switchableContainerView.layoutIfNeeded()
//                    aboutTableView.layoutIfNeeded()
                    collectionView.layoutIfNeeded()
//                    collectionView.reloadData()
//                    view.layoutIfNeeded()
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
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        if isSearching == true {
            navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }
        
//        navBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.title = "Submission"

        navigationItem.titleView = titleView
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
//        window.bringSubviewToFront(visualEffectView)
        visualEffectView.contentView.addSubview(hireAndStartAChatBtnStack)
        NSLayoutConstraint.activate([
            hireAndStartAChatBtnStack.topAnchor.constraint(equalTo: visualEffectView.contentView.topAnchor, constant: 15),
            hireAndStartAChatBtnStack.centerXAnchor.constraint(equalTo: visualEffectView.contentView.centerXAnchor),
            hireAndStartAChatBtnStack.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            hireAndStartAChatBtnStack.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }

//            self.proposalAndStartAChatBtnStack.frame = CGRect(x: 0, y: -(screenSize.height - tabHeight), width: screenSize.width, height: tabHeight)
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
        aboutSectionSetter.append(SectionHandler(title: "Summary", detail: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus elit nisi, tempor at rhoncus id, porta tincidunt metus. Nulla dictum faucibus justo. Quisque non urna nec tortor cursus lobortis. Proin quis nunc nibh. Curabitur consequat gravida augue, vitae vestibulum sem eleifend ac. Maecenas facilisis molestie vehicula. Fusce pulvinar nisi a orci iaculis bibendum."]))
        aboutSectionSetter.append(SectionHandler(title: "Skills", detail: ["skill", "skill", "skill", "skill", "skill"]))
        
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

//        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        layout.itemSize = CGSize(width:  collectionView.frame.size.width , height: aboutTableView.contentSize.height + visualEffectView.frame.height)
//        print("itemSize: \(layout.itemSize), \(aboutTableView.contentSize.height)")
//        collectionView.layoutIfNeeded()
        
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

////            switchableContainerView.bringSubviewToFront(switchableViews[currentSegmentIndex])
////            switchableViews[currentSegmentIndex].addSubview(aboutTableView)
////            aboutTableView.anchor(top: switchableViews[currentSegmentIndex].topAnchor,
////                             leading: switchableViews[currentSegmentIndex].leadingAnchor,
////                             bottom: switchableViews[currentSegmentIndex].bottomAnchor,
////                             trailing: switchableViews[currentSegmentIndex].trailingAnchor)
        
//            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//            layout.itemSize = CGSize(width:  collectionView.frame.size.width , height: aboutTableView.contentSize.height + visualEffectView.frame.height)
//            collectionView.layoutIfNeeded()
            
//            let indexPath = IndexPath (row: 0, section: 1)
//            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            if layout.sectionHeadersPinToVisibleBounds == true {
                collectionView.setContentOffset(CGPoint(x: 0.0, y: 125), animated: true)
            }
           
        case 1:

            switchableViews[currentSegmentIndex].addSubview(reviewsTableView)
            reviewsTableView.anchor(top: switchableViews[currentSegmentIndex].topAnchor,
                             leading: switchableViews[currentSegmentIndex].leadingAnchor,
                             bottom: nil,
                             trailing: switchableViews[currentSegmentIndex].trailingAnchor,
                             padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            reviewsTableView.heightAnchor.constraint(equalToConstant: reviewDynamicHeight == 0.0 ? (collectionView.frame.height) : (reviewDynamicHeight)).isActive = true
//            collectionView.layoutIfNeeded()

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
        //        let offsetY = scrollView.contentOffset.y
        //        let tableOffsetY = self.reviewsTableView.contentOffset.y
        // Handles to stick only the header on the section 1
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let offsetY = scrollView.contentOffset.y
//        print("offsetY: \(offsetY)")
        layout.sectionHeadersPinToVisibleBounds = offsetY > 125.0
        
        if offsetY >= 25.0 {
            titleView.isHidden = !(titleView.alpha > 0.001)
        }
        let alpha: CGFloat = (offsetY-25)/100
        titleView.alpha = alpha
//        print("alpha: \(alpha)")
    }
    
    
    // MARK: - Selectors
    @objc fileprivate func hireBtnPressed(_ sender: UIButton) {
        if sender.title(for: .normal) == "Hire Valter" {
            sender.setTitle("Pending...", for: .normal)
            sender.setTitleColor(.systemGray, for: .normal)
        } else {
            sender.setTitle("Hire Valter", for: .normal)
            sender.setTitleColor(.systemBlue, for: .normal)
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
      
//        cell.addSubview(reviewsTableView)
//        reviewsTableView.anchor(top: cell.topAnchor,
//                         leading: cell.leadingAnchor,
//                         bottom: cell.bottomAnchor,
//                         trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        reviewsTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: visualEffectView.frame.height/1.5, right: 0)
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewTopCell.cellID, for: indexPath) as! ReviewCollectionViewTopCell
            
            [technicianInfoMainStackView].forEach{cell.customView.addSubview($0)}
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            technicianInfoMainStackView.anchor(top: cell.customView.topAnchor, leading: cell.customView.leadingAnchor, bottom: cell.customView.bottomAnchor, trailing: cell.customView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 0), size: CGSize(width: 0, height: 0))
            
            
            //            print(cell.customView.frame.height)
            //            print(collectionView.frame.height)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewBottomCell.cellID, for: indexPath) as! ReviewCollectionViewBottomCell
//            cell.backgroundColor = .cyan
            [switchableContainerView].forEach{cell.addSubview($0)}
//            switchableContainerView.backgroundColor = .red
            switchableContainerView.anchor(top: cell.topAnchor, leading: cell.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
//            switchableContainerView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
            return cell
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let noOfCellsInRow = 1
//        /// changing sizeForItem when user switches through the segnment
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//        //        flowLayout.sectionInset.left = 5
//        //        flowLayout.sectionInset.right = 5
//
//        let size = ((collectionView.bounds.width) - totalSpace) / CGFloat(noOfCellsInRow)
//        let finalSize = CGSize(width: size, height: size)
        if indexPath.section == 0 {
//            collectionLayout.itemSize = UICollectionViewFlowLayout.automaticSize
//            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return CGSize(width: view.frame.width, height: 115)
        }
        
        let adjustedHeight: CGFloat = (view.frame.height) + reviewsTableView.contentSize.height + visualEffectView.frame.height
        switch currentSegmentIndex {
        case 0:
            return CGSize(width:  collectionView.frame.size.width , height: view.frame.height - visualEffectView.frame.height*1.5)
        case 1:
            return CGSize(width:  collectionView.frame.size.width , height: reviewsTableView.contentSize.height + visualEffectView.frame.height)
        default:
            return .zero
        }
//        return CGSize(width:  collectionView.frame.size.width , height: view.frame.height)
//        }
//        return .zero
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
            return reviewsSectionSetter.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSegmentIndex {
        case 0:
            return aboutSectionSetter[section].sectionDetail.count
        case 1:
            return reviewsSectionSetter[section].sectionDetail.count
        default:
            return aboutSectionSetter[section].sectionDetail.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch currentSegmentIndex {
        case 0:
//            let tableContentSize = aboutTableView.contentSize.height
//            let suitableHeight = (view.frame.height) + tableContentSize + visualEffectView.frame.height
//            mainContainerView.frame.size = CGSize(width: scrollView.frame.width, height: suitableHeight)
//            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: suitableHeight)

            let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.cellID, for: indexPath) as! AboutCell
            let detailText = aboutSectionSetter[indexPath.section].sectionDetail[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = detailText
            return cell
        case 1:

            let detailText = reviewsSectionSetter[indexPath.section].sectionDetail[indexPath.row]

            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProficiencyReviewCell.cellID, for: indexPath) as! ProficiencyReviewCell
                cell.setupViews()
                return cell
            case 1:
//                let tableContentSize = reviewsTableView.contentSize.height
//                let suitableHeight = (view.frame.height) + tableContentSize + visualEffectView.frame.height
//                mainContainerView.frame.size = CGSize(width: scrollView.frame.width, height: suitableHeight)
//                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: suitableHeight)

                let cell = tableView.dequeueReusableCell(withIdentifier: ProficiencyReviewCell.cellID, for: indexPath) as! ProficiencyReviewCell
//                cell.textLabel?.text = "detailText"
                cell.setupReliabilityStackView()
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell.cellID, for: indexPath) as! ReviewsCell
//                cell.textLabel?.text = detailText
                cell.setupViews()
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
            return reviewsSectionSetter[section].sectionTitle! + " (40)"
        default:
            return nil
        }
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

extension UIView {

var heightConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .height && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var widthConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .width && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

}
