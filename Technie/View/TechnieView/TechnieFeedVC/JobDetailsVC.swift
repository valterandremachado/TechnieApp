//
//  JobDetailsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/15/21.
//

import UIKit

class JobDetailsVC: UIViewController {

    var postModel: PostModel!
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .systemBackground
//        tv.tableFooterView = UIView()
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
//        if let tabHeight = tabBarController?.tabBar.frame.height {
//            tv.contentInset = .init(top: 0, left: 0, bottom: tabHeight, right: 0)
//        }

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
        btn.addTarget(self, action: #selector(proposalBtnPressed), for: .touchUpInside)
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
        let stack = UIStackView(arrangedSubviews: [proposalBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
//        stack.withWidth(view.frame.width - 100)
//        stack.withHeight(30)
        return stack
    }()
    
    var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
//        toolBar.addSubview(attachedFileBtn2)
        return toolBar
    }()
    
    var navBarViewSubtitleLbl: UILabel = {
        let subtitleLbl = UILabel()
        subtitleLbl.textColor = .systemGray
        subtitleLbl.textAlignment = .center
        subtitleLbl.text = "Posted 3 hours ago"
        subtitleLbl.font = .systemFont(ofSize: 12)
        return subtitleLbl
    }()
    
    var navBarViewTitleLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.font = .boldSystemFont(ofSize: 16)
        titleLbl.textAlignment = .center
        titleLbl.text = "Job Details"
        return titleLbl
    }()
    
    lazy var navBarTitleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [navBarViewTitleLbl, navBarViewSubtitleLbl])
        stack.axis = .vertical
        stack.spacing = -1
//        stack.addBackground(color: .red)
        return stack
    }()
    
   
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
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
//        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
        closeSelectionBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
        presentSelectionBar()
    }
    
    var dynamicBottomConstraint: NSLayoutConstraint?
    private func bottomConstraint(view: UIView) -> NSLayoutConstraint {
        guard let superview = view.superview else {
            return NSLayoutConstraint()
        }

        for constraint in superview.constraints {
            for bottom in [NSLayoutConstraint.Attribute.bottom, NSLayoutConstraint.Attribute.bottomMargin] {
                if constraint.firstAttribute == bottom && constraint.isActive && view == constraint.secondItem as? UIView {
                    return constraint
                }

                if constraint.secondAttribute == bottom && constraint.isActive && view == constraint.firstItem as? UIView {
                    return constraint
                }
            }
        }

        return NSLayoutConstraint()
    }
    // MARK: - Methods
    func setupViews() {
        [tableView].forEach { view.addSubview($0)}
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return } // SafeAreaPadding
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: tabHeight, right: 0))

        setupNavBar()
    }
    
    var isSearching = false
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navigationItem.title = "Job Details"
        isSearching ? (navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)) : (navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Feeds", style: .plain, target: self, action: nil))
       
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = navBarTitleStackView
    }
    
    fileprivate func presentSelectionBar() {
        let screenSize = UIScreen.main.bounds.size
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        // window
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        // visualEffectView
        visualEffectView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: tabHeight)
        window.addSubview(visualEffectView)

        visualEffectView.contentView.addSubview(proposalAndStartAChatBtnStack)
        NSLayoutConstraint.activate([
            proposalAndStartAChatBtnStack.topAnchor.constraint(equalTo: visualEffectView.contentView.topAnchor, constant: 15),
            proposalAndStartAChatBtnStack.centerXAnchor.constraint(equalTo: visualEffectView.contentView.centerXAnchor),
            proposalAndStartAChatBtnStack.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            proposalAndStartAChatBtnStack.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }

//            self.proposalAndStartAChatBtnStack.frame = CGRect(x: 0, y: -(screenSize.height - tabHeight), width: screenSize.width, height: tabHeight)
            self.visualEffectView.frame = CGRect(x: 0, y: screenSize.height - tabHeight, width: screenSize.width, height: tabHeight)
            
            self.visualEffectView.isHidden = false
            self.proposalAndStartAChatBtnStack.isHidden = false
            self.proposalAndStartAChatBtnStack.fadeIn()
        }, completion: nil)
    }
    
    fileprivate func closeSelectionBar() {
        self.proposalAndStartAChatBtnStack.isHidden = true
        self.visualEffectView.isHidden = true
        
        let screenSize = UIScreen.main.bounds.size
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }

            self.proposalAndStartAChatBtnStack.frame = CGRect(x: 0, y: (screenSize.height - tabHeight)/0.9, width: screenSize.width , height: 0.35)
            self.visualEffectView.frame = CGRect(x: 0, y: (screenSize.height - tabHeight)/0.9, width: screenSize.width, height: tabHeight)
            self.proposalAndStartAChatBtnStack.fadeOut()
            
        }) { (_) in
            self.proposalAndStartAChatBtnStack.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    // MARK: - Selectors
    @objc fileprivate func proposalBtnPressed() {
        let vc = SubmitProposalVC()
        vc.postID = postModel.id ?? ""
        vc.numberOfProposals = postModel.numberOfProposals
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
            cell.textLabel?.text = postModel.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell1.cellID, for: indexPath) as! JobDetailTVCell1
            cell.jobDescriptionLabel.text = postModel.description
            cell.setupViews()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell2.cellID, for: indexPath) as! JobDetailTVCell2
            cell.setupViews()
            cell.jobBudget.text = postModel.budget
            cell.jobField.text = postModel.field
            cell.jobBudget.font = .boldSystemFont(ofSize: 16)
            cell.jobField.font = .boldSystemFont(ofSize: 16)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell3.cellID, for: indexPath) as! JobDetailTVCell3
            cell.setupViews()
            cell.projectType.text = postModel.projectType
            cell.projectTypeLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell31.cellID, for: indexPath) as! JobDetailTVCell31
//            cell.setupViews()
            cell.textLabel?.text = "Attachments"
            cell.textLabel?.font = .boldSystemFont(ofSize: 16)

//            cell.attachmentLabel = postModel.attachments
//            cell.attachmentLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell4.cellID, for: indexPath) as! JobDetailTVCell4
            cell.setupViews()
            cell.dataArray = postModel.requiredSkills
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell5.cellID, for: indexPath) as! JobDetailTVCell5
            cell.setupViews()
            cell.proposals.text = "\(postModel.numberOfProposals)"
            cell.invitesSent.text = "\(postModel.numberOfInvitesSent)"
            cell.unansweredInvites.text = "\(postModel.numberOfUnansweredInvites)"
            cell.jobStatus.text = postModel.availabilityStatus == false ? ("Closed") : ("Active")

            cell.activityHeaderLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobDetailTVCell6.cellID, for: indexPath) as! JobDetailTVCell6
            cell.setupViews()
            cell.loactionLabel.text = postModel.location
//            cell.numberOfPostedJobsLabel.text = postModel.title
//            cell.statusLabel.text = postModel.title
//            cell.numberOfOpenJobsLabel.text = postModel.title

            cell.aboutTheClientHeaderLabel.font = .boldSystemFont(ofSize: 16)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 4 {
            let vc = PhotoCollectionViewerVC()
            vc.convoSharedPhotoArray = postModel.attachments
            vc.navigationItem.title = "Attachments"
            navigationController?.pushViewController(vc, animated: true)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}



// MARK: - JobDetailsVCPreviews
import SwiftUI

struct JobDetailsVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = JobDetailsVC()
        return vc.liveViewController
    }
    
}
