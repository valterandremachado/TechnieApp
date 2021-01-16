//
//  JobDetailTVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/16/21.
//

import UIKit

class JobDetailTVCell0: UITableViewCell {
    
    static let cellID = "JobDetailTVCellID0"
    
    // MARK: - Properties
    lazy var jobTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "jobTitleLabel"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [jobTitleLabel].forEach { self.addSubview($0)}
        jobTitleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - JobDetailTVCell1
class JobDetailTVCell1: UITableViewCell {
    static let cellID = "JobDetailTVCellID1"

    lazy var jobDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel"
        lbl.numberOfLines = 0
        lbl.textAlignment = .justified
//        lbl.backgroundColor = .red
        return lbl
    }()
    
    lazy var locationIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "location.fill")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0))
        iv.withWidth(20)
        return iv
    }()
    
    lazy var jobLocationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City"
        lbl.textAlignment = .left
//        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var locationStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [locationIcon, jobLocationLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .lightGray)
        return sv
    }()
    
    lazy var jobPostTimeTrackerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "3 hours ago"
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var mainStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [jobDescriptionLabel, locationStackView, jobPostTimeTrackerLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .lightGray)
        return sv
    }()
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [jobDescriptionLabel, locationStackView, jobPostTimeTrackerLabel].forEach { self.addSubview($0)}
        
        jobDescriptionLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        
        locationStackView.anchor(top: jobDescriptionLabel.bottomAnchor, leading: jobDescriptionLabel.leadingAnchor, bottom: nil, trailing: jobDescriptionLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: -5, bottom: 0, right: 0))
        
        jobPostTimeTrackerLabel.anchor(top: locationStackView.bottomAnchor, leading: jobDescriptionLabel.leadingAnchor, bottom: self.bottomAnchor, trailing: jobDescriptionLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - JobDetailTVCell2
class JobDetailTVCell2: UITableViewCell {
    
    static let cellID = "JobDetailTVCellID2"

    lazy var jobField: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Handyman"
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var jobBudget: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "$200"
        return lbl
    }()
    
    lazy var jobFieldLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Field"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var jobBudgetLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Budget"
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var budgetStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [jobBudget, jobBudgetLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var jobFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [jobField, jobFieldLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var budgetAndFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [budgetStack, jobFieldStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [budgetAndFieldStack].forEach { self.addSubview($0)}
        budgetAndFieldStack.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - JobDetailTVCell3
class JobDetailTVCell3: UITableViewCell {
    static let cellID = "JobDetailTVCellID3"

    lazy var projectTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Project Type:"
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var projectType: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Long Term"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var projectTypeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [projectTypeLabel, projectType])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [projectTypeStack].forEach { self.addSubview($0)}
        projectTypeStack.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - JobDetailTVCell4
class JobDetailTVCell4: UITableViewCell {
    static let cellID = "JobDetailTVCellID4"

    lazy var skillsHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Skills"
        return lbl
    }()
    
    lazy var skillTagsCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 5
//        collectionLayout.minimumInteritemSpacing = 10
//        collectionLayout.estimatedItemSize = .zero
//        collectionLayout.itemSize = .init(width: 50, height: 25)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.isScrollEnabled = false
//        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Avoid collectionView to self adjust its size
//        cv.contentInsetAdjustmentBehavior = .never
        let numberOfCharInEachElement = dataArray.map {$0.count}
        let totalSumOfTheChars = numberOfCharInEachElement.reduce(0, +)
//        print(numberOfCharInEachElement, totalSumOfTheChars)
        if dataArray.count <= 4 && totalSumOfTheChars <= 34 {
            // for 1 row
            cv.withHeight(30)
        } else {
            // for potentially 2 row
            cv.withHeight(65)
        }
        
        cv.delegate = self
        cv.dataSource = self
        // Registration of the cell
        cv.register(SkillTagsCell.self, forCellWithReuseIdentifier: SkillTagsCell.cellID)
       
        return cv
    }()
    
    let dataArray = ["repairer", "handyman", "electrician", "plumber"]

    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [skillsHeaderLabel, skillTagsCollectionView].forEach { self.addSubview($0)}
        skillsHeaderLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        skillTagsCollectionView.anchor(top: skillsHeaderLabel.bottomAnchor, leading: skillsHeaderLabel.leadingAnchor, bottom: self.bottomAnchor, trailing: skillsHeaderLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JobDetailTVCell4: CollectionDataSourceAndDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillTagsCell.cellID, for: indexPath) as! SkillTagsCell
        cell.textLabel.text = dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = dataArray[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 5, height: 30)
    }
    
}

// MARK: - JobDetailTVCell5
class JobDetailTVCell5: UITableViewCell {
    static let cellID = "JobDetailTVCellID5"

    lazy var activityHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Activity on this job"
        return lbl
    }()
    
    lazy var proposalsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Proposals:"
        return lbl
    }()
    
    lazy var negotiationsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Negotiating:"
        return lbl
    }()
    
    lazy var invitesSentLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Invites Sent:"
        return lbl
    }()
    
    lazy var unansweredInvitesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Unanswered Invites:"
        return lbl
    }()
    
    lazy var proposals: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "1"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var negotiations: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "2"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var invitesSent: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "3"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var unansweredInvites: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "4"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var proposalsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [proposalsLabel, proposals])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    lazy var negotiationsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [negotiationsLabel, negotiations])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    lazy var invitesSentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [invitesSentLabel, invitesSent])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    lazy var unansweredInvitesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [unansweredInvitesLabel, unansweredInvites])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [proposalsStack, negotiationsStack, invitesSentStack, unansweredInvitesStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [activityHeaderLabel, mainStack].forEach { self.addSubview($0)}
        activityHeaderLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        mainStack.anchor(top: activityHeaderLabel.bottomAnchor, leading: activityHeaderLabel.leadingAnchor, bottom: self.bottomAnchor, trailing: activityHeaderLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - JobDetailTVCell6
class JobDetailTVCell6: UITableViewCell {
    static let cellID = "JobDetailTVCellID6"

    lazy var aboutTheClientHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "About the client"
        return lbl
    }()
    
    lazy var loactionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City"
        return lbl
    }()
    
    lazy var statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Active 30 mins ago"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)

        return lbl
    }()
    
    lazy var numberOfPostedJobsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "20 jobs posted"
        return lbl
    }()
    
    lazy var numberOfOpenJobsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "2 open jobs"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    lazy var dateOfMembershipLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Member since August 21, 2014"
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var stack1: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loactionLabel, statusLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    
    lazy var stack2: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [numberOfPostedJobsLabel, numberOfOpenJobsLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stack1, stack2, dateOfMembershipLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
//        stack.withHeight(40)
        return stack
    }()
   
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [aboutTheClientHeaderLabel, mainStack].forEach { self.addSubview($0)}
        aboutTheClientHeaderLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        mainStack.anchor(top: aboutTheClientHeaderLabel.bottomAnchor, leading: aboutTheClientHeaderLabel.leadingAnchor, bottom: self.bottomAnchor, trailing: aboutTheClientHeaderLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JobDetailTVCell31: UITableViewCell {
    
    static let cellID = "JobDetailTVCellID31"
    
    // MARK: - Properties
    lazy var attachmentLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Attachment"
//        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var attachedFileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("png (24k)", for: .normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
        [attachmentLabel, attachedFileBtn].forEach { contentView.addSubview($0)}
        attachmentLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        
        attachedFileBtn.anchor(top: attachmentLabel.bottomAnchor, leading: attachmentLabel.leadingAnchor, bottom: contentView.bottomAnchor, trailing: attachmentLabel.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}