//
//  RankedTechnieVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/19/20.
//

import UIKit

class RankedTechnieVC: UIViewController {
    // MARK: - Properties
    lazy var technicianCoverPicture: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "technieDummyPhoto")
        return iv
    }()
    
    lazy var roundedTopCornerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .systemBackground
        view.roundTopLeftAndRightCorners(radius: 25)
        return view
    }()
    
    lazy var shorterRoundedTopCornerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        view.roundTopLeftAndRightCorners(radius: 25)

        return view
    }()
    
    lazy var technicianNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter \nA. Machado"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .boldSystemFont(ofSize: 30)//.systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var briefSummaryLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus elit nisi, tempor at rhoncus id, porta tincidunt metus. Nulla dictum faucibus justo. Quisque non urna nec tortor cursus lobortis. Proin quis nunc nibh."
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
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
        lbl.text = "• 8 year of Exp."
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
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [rankingLabel, technicianExperienceLabel, memberShipDateLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .leading
        sv.distribution = .fillEqually
//        sv.addBackground(color: .brown)
        return sv
    }()
    
    
    lazy var completeProfileLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Complete Profile"
        lbl.textAlignment = .left
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
//        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var profileDetailsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Skills | Rating | Reviews | Reliability"
        lbl.textAlignment = .left
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
//        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var checkProfileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(25))
        var wiredProfileImage = UIImage(systemName: "chevron.forward.circle.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        btn.setImage(wiredProfileImage, for: .normal)
        btn.contentHorizontalAlignment = .trailing
//        btn.backgroundColor = .white
//        btn.withWidth(50)
        btn.addTarget(self, action: #selector(checkProfileBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [completeProfileLabel, profileDetailsLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .brown)
        return sv
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.clipsToBounds = true
//        tv.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ProficiencyReviewCell.self, forCellReuseIdentifier: ProficiencyReviewCell.cellID)
        return tv
    }()
    
    var stringPrint = ""
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        print("stringPrint: "+stringPrint)
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reset navBar appearance to default
        navigationController?.navigationBar.defaultNavBarAppearance()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        // Add subViews on the main viewRoot
        [technicianCoverPicture, roundedTopCornerView, shorterRoundedTopCornerView].forEach {view.addSubview($0)}
        view.bringSubviewToFront(shorterRoundedTopCornerView)
        
        technicianCoverPicture.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: roundedTopCornerView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0))
        
        roundedTopCornerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: view.frame.height/1.8))
        // Add subViews on roundedTopCornerView
        [technicianNameLabel, briefSummaryLabel, stackView, tableView].forEach {roundedTopCornerView.addSubview($0)}
        
        technicianNameLabel.anchor(top: roundedTopCornerView.safeAreaLayoutGuide.topAnchor, leading: roundedTopCornerView.leadingAnchor, bottom: nil, trailing: roundedTopCornerView.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 25, bottom: 0, right: 25), size: CGSize(width: 0, height: 0))
        
        briefSummaryLabel.anchor(top: technicianNameLabel.bottomAnchor, leading: technicianNameLabel.leadingAnchor, bottom: nil, trailing: technicianNameLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        stackView.anchor(top: briefSummaryLabel.bottomAnchor, leading: technicianNameLabel.leadingAnchor, bottom: nil, trailing: technicianNameLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        tableView.anchor(top: stackView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        shorterRoundedTopCornerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: view.frame.height/7.2))
        // Add subViews on shorterRoundedTopCornerView
        [checkProfileBtn, stackView2].forEach {shorterRoundedTopCornerView.addSubview($0)}
        
        checkProfileBtn.anchor(top: shorterRoundedTopCornerView.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: roundedTopCornerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 25), size: CGSize(width: 30, height: 30))
        
        stackView2.anchor(top: checkProfileBtn.topAnchor, leading: shorterRoundedTopCornerView.leadingAnchor, bottom: nil, trailing: checkProfileBtn.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.clearNavBarAppearance()
        navBar.topItem?.title = ""
//        navBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
        let leftNavBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(leftNavBarBtnTapped))
            //UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftNavBarBtnTapped))

        self.navigationItem.leftBarButtonItem = leftNavBarButton
//        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    // MARK: - Selectors
    @objc fileprivate func checkProfileBtnPressed() {
        let vc = TechnicianProfileDetailsVC()
        vc.isModalInPresentation = true
//        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableViewDataSourceAndDelegate Extension
extension RankedTechnieVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProficiencyReviewCell.cellID, for: indexPath) as! ProficiencyReviewCell
        cell.setupViews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
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
