//
//  JobDetailsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/15/21.
//

import UIKit

class JobDetailsVC: UIViewController {

    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
//        collectionLayout.minimumLineSpacing = 8
//        collectionLayout.minimumInteritemSpacing = 8
//        collectionLayout.estimatedItemSize = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Avoid collectionView to self adjust its size
        //        cv.contentInsetAdjustmentBehavior = .never
        
        cv.delegate = self
        cv.dataSource = self
        // Registration of the cell
        cv.register(JobDetailCVCell.self, forCellWithReuseIdentifier: JobDetailCVCell.cellID)
        return cv
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 400
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(JobDetailTVCell0.self, forCellReuseIdentifier: JobDetailTVCell0.cellID)
        tv.register(JobDetailTVCell1.self, forCellReuseIdentifier: JobDetailTVCell1.cellID)
        tv.register(JobDetailTVCell2.self, forCellReuseIdentifier: JobDetailTVCell2.cellID)
        tv.register(JobDetailTVCell3.self, forCellReuseIdentifier: JobDetailTVCell3.cellID)
        tv.register(JobDetailTVCell31.self, forCellReuseIdentifier: JobDetailTVCell31.cellID)
        tv.register(JobDetailTVCell4.self, forCellReuseIdentifier: JobDetailTVCell4.cellID)
        tv.register(JobDetailTVCell5.self, forCellReuseIdentifier: JobDetailTVCell5.cellID)
        tv.register(JobDetailTVCell6.self, forCellReuseIdentifier: JobDetailTVCell6.cellID)

        return tv
    }()
    
    lazy var proposalBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit Proposal", for: .normal)
//        btn.contentHorizontalAlignment = .left
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.backgroundColor = .cyan
//        btn.withWidth(180)
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
    
    lazy var proposalAndStartAChatBtnStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [proposalBtn, startAChatBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        stack.withWidth(view.frame.width - 100)
        stack.withHeight(30)
        return stack
    }()
    
    var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
//        toolBar.addSubview(attachedFileBtn2)
        return toolBar
    }()
    
    lazy var navBarTitleStackView: UIStackView = {
        let titleLbl = UILabel()
        titleLbl.font = .boldSystemFont(ofSize: 16)
        titleLbl.textAlignment = .center
        titleLbl.text = "Job Details"
        
        let subtitleLbl = UILabel()
        subtitleLbl.textColor = .systemGray
        subtitleLbl.textAlignment = .center
        subtitleLbl.text = "Posted 3 hours ago"
        subtitleLbl.font = .systemFont(ofSize: 12)
        let stack = UIStackView(arrangedSubviews: [titleLbl, subtitleLbl])
        stack.axis = .vertical
        stack.spacing = -1
//        stack.addBackground(color: .red)
        return stack
    }()
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        setupViews()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
    }
    
    // MARK: - Methods
    func setupViews() {
        [tableView, toolBar].forEach { view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: toolBar.topAnchor, trailing: view.trailingAnchor)
        toolBar.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 44))
        
//        toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 35))

        toolBar.addSubview(proposalAndStartAChatBtnStack)
        
        NSLayoutConstraint.activate([
            proposalAndStartAChatBtnStack.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor),
            proposalAndStartAChatBtnStack.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
        ])

//        toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 35))
        setupNavBar()
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navigationItem.title = "Job Details"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = navBarTitleStackView
    }
    
    // MARK: - Selectors

}

// MARK: - CollectionDataSourceAndDelegate Extension
extension JobDetailsVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell0.cellID, for: indexPath) as! JobDetailTVCell0
//            cell.setupViews()
            cell.textLabel?.font = .boldSystemFont(ofSize: 20)
            cell.textLabel?.text = "Job Title"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell1.cellID, for: indexPath) as! JobDetailTVCell1
            cell.setupViews()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell2.cellID, for: indexPath) as! JobDetailTVCell2
            cell.setupViews()
            cell.jobBudget.font = .boldSystemFont(ofSize: 16)
            cell.jobField.font = .boldSystemFont(ofSize: 16)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell3.cellID, for: indexPath) as! JobDetailTVCell3
            cell.setupViews()
            cell.projectTypeLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell31.cellID, for: indexPath) as! JobDetailTVCell31
            cell.setupViews()
            cell.attachmentLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell4.cellID, for: indexPath) as! JobDetailTVCell4
            cell.setupViews()
            cell.skillsHeaderLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell5.cellID, for: indexPath) as! JobDetailTVCell5
            cell.setupViews()
            cell.activityHeaderLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell6.cellID, for: indexPath) as! JobDetailTVCell6
            cell.setupViews()
            cell.aboutTheClientHeaderLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}


// MARK: - CollectionDataSourceAndDelegate Extension
extension JobDetailsVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobDetailCVCell.cellID, for: indexPath) as! JobDetailCVCell
        switch indexPath.row {
        case 0:
            cell.setupViewsOnItem0()
            return cell
        case 1:
            print("1")
            cell.setupViewsOnItem1()
            return cell
        case 2:
            print("2")
            return cell
        case 3:
            print("3")
            return cell
        case 4:
            print("4")
            return cell
        case 5:
            print("5")
            return cell
        case 6:
            print("6")
            return cell
        default:
            return UICollectionViewCell()
        }
//        if indexPath.row == 0 {
//            cell.setupViewsOnItem0()
//        }
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 1
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//            flowLayout.sectionInset.left = 2
//            flowLayout.sectionInset.right = 2
        
        let size = ((collectionView.bounds.width) - totalSpace) / CGFloat(noOfCellsInRow)
        let finalSize = CGSize(width: size, height: size)
        
        return finalSize
    }
    
}
