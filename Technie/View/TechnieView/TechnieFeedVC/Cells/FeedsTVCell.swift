//
//  FeedsTVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/14/21.
//

import UIKit
import TTGTagCollectionView

class FeedsTVCell: UITableViewCell {
    
    static let cellID = "FeedsTVCellID"
    
    // MARK: - Properties
    lazy var jobTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "jobTitleLabel"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var jobDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel"
        lbl.numberOfLines = 0
        lbl.textAlignment = .justified
//        lbl.backgroundColor = .red
        return lbl
    }()
    
    lazy var jobLocation: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City"
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var jobBudget: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "$200"
        return lbl
    }()
    
    lazy var jobLocationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Location"
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
    
    lazy var jobPostTimeTrackerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "3 hours ago"
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var jobSkillsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Skill 1 Skill 2 Skill 3 Skill 4 Skill 5"
        return lbl
    }()
    
    lazy var likeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("Like", for: .normal)
        btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        btn.withWidth(30)
//        btn.backgroundColor = .gray
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        return btn
    }()
    
    lazy var titleAndLikeBtnStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [jobTitleLabel, likeBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
//        stack.addBackground(color: .cyan)
        return stack
    }()
    
    lazy var budgetStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [jobBudget, jobBudgetLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var locationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [jobLocation, jobLocationLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var budgetAndLocationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [budgetStack, locationStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
        stack.withHeight(40)
        return stack
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleAndLikeBtnStack, jobDescriptionLabel, budgetAndLocationStack, jobSkillsLabel, jobPostTimeTrackerLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
//        stack.spacing = 2
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var skillTagsCollectionView: TTGTextTagCollectionView = {
        let tag = TTGTextTagCollectionView()
        tag.isUserInteractionEnabled = false
        tag.enableTagSelection = false
//        tag.delegate = self
        tag.alignment = .left
        tag.clipsToBounds = true

        return tag
    }()
    
    var dataArray = [String]()
    var currentTime = Date()

    var postModel: PostModel! {
        didSet {
            jobTitleLabel.text = postModel.title
            jobDescriptionLabel.text = postModel.description
            jobBudget.text = postModel.budget
            jobLocation.text = postModel.postOwnerInfo?.location
            dataArray = postModel.requiredSkills
            jobPostTimeTrackerLabel.text = calculateTimeFrame(initialTime: postModel.dateTime)
            
            // Avoid duplicated items as this didSet is called multiple times
            if  skillTagsCollectionView.allTags()?.count == 0 {
                let config = TTGTextTagConfig()
                config.backgroundColor = .systemGray5
                config.textColor = .black
                config.borderWidth = 0.5
                config.borderColor = .lightGray
                config.cornerRadius = 15
                config.exactHeight = 25
                config.textFont = .systemFont(ofSize: 13.5)

                skillTagsCollectionView.addTags(dataArray, with: config)
                return
            }
           
        }
    
    }
    
//    func calculateTimeFrame(initialTime: String) -> String {
//        guard let start = PostFormVC.dateFormatter.date(from: initialTime) else { return }
//        guard let end = PostFormVC.dateFormatter.date(from: PostFormVC.dateFormatter.string(from: Date())) else { return }
//
//        let relativeDateTime = RelativeDateTimeFormatter()
//        relativeDateTime.unitsStyle = .full
//        let timeFrame = relativeDateTime.localizedString(for: start, relativeTo: end)
//        return timeFrame
//    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func setupViews() {
//        titleAndLikeBtnStack, jobDescriptionLabel, budgetAndLocationStack, jobSkillsLabel, jobPostTimeTrackerLabel
        [titleAndLikeBtnStack, jobDescriptionLabel, budgetAndLocationStack, skillTagsCollectionView, jobPostTimeTrackerLabel].forEach {contentView.addSubview($0)}
        
        titleAndLikeBtnStack.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 10, left: self.separatorInset.left + 6, bottom: 0, right: self.separatorInset.right + 15)) //
        
        jobDescriptionLabel.anchor(top: titleAndLikeBtnStack.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: nil, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        budgetAndLocationStack.anchor(top: jobDescriptionLabel.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: nil, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        skillTagsCollectionView.anchor(top: budgetAndLocationStack.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: nil, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        jobPostTimeTrackerLabel.anchor(top: skillTagsCollectionView.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: contentView.bottomAnchor, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: - Selectors

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// CollectionDataSourceAndDelegate Extension
//extension FeedsTVCell: TTGTextTagCollectionViewDelegate {
//
//}
