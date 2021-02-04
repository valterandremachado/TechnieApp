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

        return lbl
    }()
    
    lazy var ratingAndReviewsStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        
        let sv = UIStackView(arrangedSubviews: [iconIV, ratingAndReviewsLabel])
        sv.axis = .horizontal
        sv.spacing = 2
        sv.alignment = .leading
        sv.distribution = .fill
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
        view.backgroundColor = .green
        return view
    }()
    
    lazy var switchableContainerView2: UIView = {
        let view = UIView()
//        view.frame.size = contentViewSize
        view.backgroundColor = .green
        return view
    }()
    
    lazy var switchableContainerView3: UIView = {
        let view = UIView()
//        view.frame.size = contentViewSize
        view.backgroundColor = .red
        return view
    }()
    
    lazy var switchableContainerView4: UIView = {
        let view = UIView()
//        view.frame.size = contentViewSize
        view.backgroundColor = .red
        return view
    }()
    
    var switchableViews = [UIView]()
    
    var sectionSetter = [SectionHandler]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        
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
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(AboutCell.self, forCellReuseIdentifier: AboutCell.cellID)
        return tv
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let heights = profileImageView.frame.height
            + tableView.frame.height
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
    
    var dynamicHeight: NSLayoutConstraint?
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
//        switchableContainerView2.anchor(top: switchableContainerView.bottomAnchor, leading: mainContainerView.leadingAnchor, bottom: nil, trailing: mainContainerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 200))
//        switchableContainerView3.anchor(top: switchableContainerView2.bottomAnchor, leading: mainContainerView.leadingAnchor, bottom: nil, trailing: mainContainerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 200))
//        switchableContainerView4.anchor(top: switchableContainerView3.bottomAnchor, leading: mainContainerView.leadingAnchor, bottom: mainContainerView.bottomAnchor, trailing: mainContainerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 200))
        
//        let heights = profileImageView.frame.height
//            + mainStackView.frame.height
//            + customSegmentedControl.frame.height
//            + switchableContainerView.frame.height
//            + switchableContainerView2.frame.height
//            + switchableContainerView3.frame.height
//        contentViewSize.height = view.frame.height + heights
        
//        scrollView.withHeight(heights)
        view.layoutIfNeeded()

        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.title = "Submission"
    }
    
    
    fileprivate func populateSections() {
        sectionSetter.append(SectionHandler(title: "Summary", detail: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus elit nisi, tempor at rhoncus id, porta tincidunt metus. Nulla dictum faucibus justo. Quisque non urna nec tortor cursus lobortis. Proin quis nunc nibh. Curabitur consequat gravida augue, vitae vestibulum sem eleifend ac. Maecenas facilisis molestie vehicula. Fusce pulvinar nisi a orci iaculis bibendum."]))
        sectionSetter.append(SectionHandler(title: "Skills", detail: ["skill", "skill", "skill", "skill", "skill"]))
    }
    
    
    fileprivate func setupSwitchableContainerView() {
        // Add the VCs containterView to the switchableViews array
        switchableViews.append(AboutVC().view)
        switchableViews.append(ReviewsVC().view)

//        for view in switchableViews {
//            switchableContainerView.addSubview(view)
//        }
        
        // removeFromSuperview the view that is not being displayed for a better memory efficiency
        switchableContainerView.addSubview(switchableViews[0])
        switchableViews[0].frame = switchableContainerView.bounds
        switchableViews[0].addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.anchor(top: switchableViews[0].topAnchor,
                         leading: switchableViews[0].leadingAnchor,
                         bottom: switchableViews[0].bottomAnchor,
                         trailing: switchableViews[0].trailingAnchor)
        switchableViews[1].removeFromSuperview()
    }
    
    func change(to index: Int) {
        currentSegmentIndex = index
        print("segmentedControl index changed to \(index)")
        //        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .transitionFlipFromLeft, animations: { [self] in
        switchableContainerView.addSubview(switchableViews[index])
        switchableViews[index].frame = switchableContainerView.bounds
//        switchableViews[index].frame.size = switchableContainerView.frame.size
        //        switchableContainerView.bringSubviewToFront(switchableViews[index])
        switchableViews[index == 1 ? (0) : (1)].removeFromSuperview()
        //        }, completion: nil)
        
    }
    
    
    // MARK: - Selectors

}
// MARK: - TableViewDelegateAndDataSource Extension
extension TechnicianProfileDetailsVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSetter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionSetter[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.cellID, for: indexPath) as! AboutCell
        let detailText = sectionSetter[indexPath.section].sectionDetail[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = detailText
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionSetter[section].sectionTitle
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
