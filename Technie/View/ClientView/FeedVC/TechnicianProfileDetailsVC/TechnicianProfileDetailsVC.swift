//
//  TechnicianProfileDetailsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/3/21.
//

import UIKit

class TechnicianProfileDetailsVC: UIViewController, CustomSegmentedControlDelegate {

    // MARK: - Properties
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
        lbl.font = .systemFont(ofSize: 12.5)
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
//        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var ratingAndReviewsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = " 4.5 (40)"//★
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
//        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var ratingAndReviewsStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        
        let sv = UIStackView(arrangedSubviews: [iconIV, ratingAndReviewsLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .red)
        return sv
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
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, locationLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 0
        sv.distribution = .equalSpacing
//        sv.addBackground(color: .red)
        return sv
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)

    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame : .zero)
        var frame = CGRect.init()
        let screenSize = UIScreen.main.bounds.size
        screenSize.height <= 667 ? (frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! - (navigationController?.navigationBar.frame.height)!/1.8, width: contentViewSize.width, height: contentViewSize.height - (navigationController?.navigationBar.frame.height)!/2)) : (frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! - (navigationController?.navigationBar.frame.height)!/2, width: contentViewSize.width, height: contentViewSize.height - (navigationController?.navigationBar.frame.height)!))
    
        view.frame = frame
        view.contentInsetAdjustmentBehavior = .never
        view.contentSize = contentViewSize
        view.backgroundColor = .systemBackground
        return view
    }()

    lazy var mainContainerView: UIView = {
        let view = UIView()
//        view.frame.size = contentViewSize
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var switchableContainerView: UIView = {
        let view = UIView()
//        view.frame.size = contentViewSize
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
        
//        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.clipsToBounds = true
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ReviewsCell0.self, forCellReuseIdentifier: ReviewsCell0.cellID)
        tv.register(ReviewsCell.self, forCellReuseIdentifier: ReviewsCell.cellID)
        return tv
    }()
    
    lazy var hireBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Hire Valter", for: .normal)
//        btn.contentHorizontalAlignment = .left
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.backgroundColor = .cyan
//        btn.withWidth(180)
//        btn.addTarget(self, action: #selector(proposalBtnPressed), for: .touchUpInside)
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
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
        setupSwitchableContainerView()
        populateSections()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
        closeSelectionBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
        presentSelectionBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let heights = profileImageView.frame.height
            + aboutTableView.frame.height
            + mainStackView.frame.height
            + customSegmentedControl.frame.height
            + switchableContainerView.frame.height
//        contentViewSize.height = view.frame.height + heights
//        let remainHeight = heights - mainContainerView.frame.height
//        let thisHeight = heights - scrollView.frame.height //- mainContainerView.frame.height
        
       
        
//        print("content height: \(heights), mainContainerView height: \(mainContainerView.frame.height), scrollView height: \(scrollView.frame.height), remainHeight: \(viewHeight)")
//        print("dynamicHeight height: \(dynamicHeight?.constant), \(thisHeight)")
//        let screenSize = UIScreen.main.bounds.size

//        dynamicHeight?.isActive = false
//        dynamicHeight?.constant = scrollView.frame.height + viewHeight
//        dynamicHeight?.isActive = true
//        print("dynamicHeight height2: \(dynamicHeight?.constant)")

//        view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    var dynamicHeight: NSLayoutConstraint?
    // MARK: - Methods
    fileprivate func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainContainerView)
        [mainStackView, profileImageView, customSegmentedControl, switchableContainerView].forEach {mainContainerView.addSubview($0)}
        
        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        let viewHeight = view.frame.height - (navBarHeight - tabBarHeight)

//        guard let paddingToNavBarHeight = navigationController?.navigationBar.frame.height else { return }
        mainContainerView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: scrollView.frame.width, height: viewHeight + 15))
//        dynamicHeight = mainContainerView.heightAnchor.constraint(equalToConstant: 0)
//        dynamicHeight?.isActive = true

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: mainContainerView.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])

        mainStackView.anchor(top: profileImageView.bottomAnchor, leading: mainContainerView.leadingAnchor, bottom: nil, trailing: mainContainerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        customSegmentedControl.anchor(top: mainStackView.bottomAnchor, leading: mainContainerView.leadingAnchor, bottom: nil, trailing: mainContainerView.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 30))
        
        switchableContainerView.anchor(top: customSegmentedControl.bottomAnchor, leading: mainContainerView.leadingAnchor, bottom: mainContainerView.bottomAnchor, trailing: mainContainerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))

//        view.layoutIfNeeded()
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.title = "Submission"
    }
    
    fileprivate func presentSelectionBar() {
        let screenSize = UIScreen.main.bounds.size
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        // window
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        // visualEffectView
        visualEffectView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: tabHeight)
        window.addSubview(visualEffectView)

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
        reviewsSectionSetter.append(SectionHandler(title: "Reviews", detail: ["Reviews", "Reviews", "Reviews", "Reviews", "Reviews"]))
    }
    
    let customReviewView = UIView()
    let customAboutView = UIView()

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
                         bottom: switchableViews[0].bottomAnchor,
                         trailing: switchableViews[0].trailingAnchor)
        
        switchableViews[1].fadeOut()
        // Using timer to avoid unsmooth fade animation caused by the same view that is being faded then later on removeFromSuperview
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) { [self] in
            DispatchQueue.main.async {
                switchableViews[1].removeFromSuperview()
            }
        }
    }
    
    func change(to index: Int) {
        currentSegmentIndex = index
        print("segmentedControl index changed to \(index)")

        switchableViews[index].fadeOut()
        switchableContainerView.addSubview(switchableViews[index])
        switchableViews[index].frame = switchableContainerView.bounds
        switchableViews[index].fadeIn()
        
        switch currentSegmentIndex {
        case 1:
            switchableViews[currentSegmentIndex].addSubview(reviewsTableView)
//            [ratingAndReviewsStackView, reviewsTableView].forEach {switchableViews[currentSegmentIndex].addSubview($0)}
//            ratingAndReviewsStackView.anchor(top: switchableViews[currentSegmentIndex].topAnchor, leading: nil, bottom: nil, trailing: nil)
//            NSLayoutConstraint.activate([
//                ratingAndReviewsStackView.widthAnchor.constraint(equalToConstant: 95),
//                ratingAndReviewsStackView.heightAnchor.constraint(equalToConstant: 30),
//                ratingAndReviewsStackView.centerXAnchor.constraint(equalTo: switchableViews[currentSegmentIndex].centerXAnchor),
//            ])
            
            reviewsTableView.anchor(top: switchableViews[currentSegmentIndex].topAnchor,
                             leading: switchableViews[currentSegmentIndex].leadingAnchor,
                             bottom: switchableViews[currentSegmentIndex].bottomAnchor,
                             trailing: switchableViews[currentSegmentIndex].trailingAnchor)
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
    
    
    // MARK: - Selectors

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
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.cellID, for: indexPath) as! AboutCell
            let detailText = aboutSectionSetter[indexPath.section].sectionDetail[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = detailText
            return cell
        case 1:
            let detailText = reviewsSectionSetter[indexPath.section].sectionDetail[indexPath.row]

            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell0.cellID, for: indexPath) as! ReviewsCell0
                cell.setupViews()
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell0.cellID, for: indexPath) as! ReviewsCell0
//                cell.textLabel?.text = "detailText"
                cell.setupViews2()
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell.cellID, for: indexPath) as! ReviewsCell
                cell.textLabel?.text = detailText
                return cell
            default:
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
       
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
