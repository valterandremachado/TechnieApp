//
//  FeedsTVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/14/21.
//

import UIKit
import TTGTagCollectionView
import TagListView
//import ExpandableLabel
//import TTTAttributedLabel
import ReadMoreTextView

class FeedsTVCell: UITableViewCell {
    
    static let cellID = "FeedsTVCellID"
    
    // MARK: - Properties
    var linkedDelegate: TechnieFeedVCDelegate?
    
    lazy var jobTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "jobTitleLabel"
        lbl.font = .boldSystemFont(ofSize: 16)
//        lbl.backgroundColor = .cyan
        return lbl
    }()
    
//    var jobDescriptionLabel = ExpandableLabel()
//    var jobDescriptionLabel = TTTAttributedLabel()

    lazy var jobDescriptionLabel: UILabel = {
        let lbl = UILabel()
//        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel jobDescriptionLabel"
        
      
        lbl.numberOfLines = 4
//        var trunc = NSMutableAttributedString(string: "...See More")
//        trunc.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: NSMakeRange(0, 11))
//        trunc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSMakeRange(0, 11))
//        trunc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, 3))
//        lbl.attributedTruncationToken = trunc

        lbl.textAlignment = .justified

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
//        lbl.withHeight(20)
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
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.withWidth(30)
//        btn.backgroundColor = .gray
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        btn.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
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
    
    lazy var titleAndDescriptionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleAndLikeBtnStack, jobDescriptionLabelContainerView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
//        stack.spacing = 2
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var skillTagsCollectionViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skillTagsCollectionView)
        skillTagsCollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//        view.backgroundColor = .cyan

        return view
    }()
    
    lazy var jobDescriptionLabelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(jobDescriptionLabel)
        jobDescriptionLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//        view.backgroundColor = .red

        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleAndLikeBtnStack, jobDescriptionLabelContainerView, budgetAndLocationStack, skillTagsCollectionViewContainerView, jobPostTimeTrackerLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        return stack
    }()
    
    lazy var skillTagsCollectionView: TTGTextTagCollectionView = {
        let tag = TTGTextTagCollectionView()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.isUserInteractionEnabled = false
        tag.enableTagSelection = false
//        tag.delegate = self
        tag.alignment = .left
        tag.clipsToBounds = true
//        tag.backgroundColor = .cyan
//        tag.textFont = .systemFont(ofSize: 13.5)
//        tag.cornerRadius = 3
        
        return tag
    }()
    
    var dataArray = [String]()
    var currentTime = Date()

    var labelDynamicHeight: CGFloat = 0
    var lesserHeight: CGFloat = 0
    
    var postModel: PostModel! {
        didSet {
            jobTitleLabel.text = postModel.title
            jobDescriptionLabel.text = postModel.description
            
            labelDynamicHeight = LabelDynamicHeight.height(text: postModel.description, font: UIFont.systemFont(ofSize: 17), width: self.frame.width - self.separatorInset.left + 6)
            
            jobBudget.text = postModel.budget
            jobLocation.text = postModel.postOwnerInfo?.location
            dataArray = postModel.requiredSkills
            jobPostTimeTrackerLabel.text = calculateTimeFrame(initialTime: postModel.dateTime)
            
//             Avoid duplicated items as this didSet is called multiple times
            if  skillTagsCollectionView.allTags()?.count == 0 {
                let config = TTGTextTagConfig()
                config.backgroundColor = .systemGray5
                config.textColor = .black
                config.borderWidth = 0.5
                config.borderColor = .lightGray
                config.cornerRadius = 15
                config.exactHeight = 25
                config.textFont = .systemFont(ofSize: 13.5)
                skillTagsCollectionView.numberOfLines = 2

                skillTagsCollectionView.addTags(dataArray, with: config)
                return
            }


            
//            jobDescriptionLabelContainerView.withHeight(labelDynamicHeight)
////            jobDescriptionLabelContainerView.layoutIfNeeded()
//            skillTagsCollectionView.layoutIfNeeded()

           
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
        [mainStack].forEach {contentView.addSubview($0)}
//        jobPostTimeTrackerLabel.backgroundColor = .red
        mainStack.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 10, left: self.separatorInset.left + 6, bottom: 10, right: self.separatorInset.right + 15)) //
       
//        jobDescriptionLabel.anchor(top: titleAndLikeBtnStack.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: nil, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
//
//        budgetAndLocationStack.anchor(top: jobDescriptionLabel.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: nil, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
//
//        skillTagsCollectionView.anchor(top: budgetAndLocationStack.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: nil, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
//
//        jobPostTimeTrackerLabel.anchor(top: skillTagsCollectionView.bottomAnchor, leading: titleAndLikeBtnStack.leadingAnchor, bottom: contentView.bottomAnchor, trailing: titleAndLikeBtnStack.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: - Selectors
    @objc private func likeBtnPressed(_ sender: UIButton){
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        }, completion: nil)
        
//        let imageSaved = UIImage(systemName: "heart.fill")
//        let imageUnsaved = UIImage(systemName: "heart")

        linkedDelegate?.saveJobLinkMethod(cell: self, button: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// CollectionDataSourceAndDelegate Extension
extension FeedsTVCell: TTGTextTagCollectionViewDelegate {

}
extension UILabel {

    func autoresize() {
        if let textNSString: NSString = self.text as NSString? {
            let rect = textNSString.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: self.font],
                context: nil)
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: rect.height)
        }
    }
    
}

class LabelDynamicHeight {
    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        var currentHeight: CGFloat!
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
        return currentHeight
    }
}
