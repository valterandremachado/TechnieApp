//
//  FeedsTVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/14/21.
//

import UIKit

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
    
    var dataArray = [String]()
    
    var postModel: PostModel! {
        didSet {
            jobTitleLabel.text = postModel.title
            jobDescriptionLabel.text = postModel.description
            jobBudget.text = postModel.budget
            jobLocation.text = postModel.location
            dataArray = postModel.requiredSkills
            jobPostTimeTrackerLabel.text = postModel.dateTime
        }
    }
    
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
extension FeedsTVCell: CollectionDataSourceAndDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillTagsCell.cellID, for: indexPath) as! SkillTagsCell
        cell.textLabel.text = dataArray[indexPath.item]
//        var heights = [10.0,20.0,30.0,40.0,50.0,60.0,70.0,80.0,90.0,100.0,110.0] as [CGFloat]
//        let some = heights[indexPath.row]
//        cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: heights[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = dataArray[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 10, height: 30)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let noOfCellsInRow = 2
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
//        
////        let viewSize = view.frame.size
////        var collectionViewSize = CGSize(width: 0, height: 0)
//        
//        return finalSize
//    }
}


class SkillTagsCell: UICollectionViewCell {
    static let cellID = "SkillTagsCellID"
    // MARK: - Properties
    lazy var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = "Skill 1 Skill 2 Skill 3 Skill 4 Skill 5"
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 13.5)
        return lbl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray5
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        // Customize Cell
        self.layer.cornerRadius = 15
        self.clipsToBounds = true

        [textLabel].forEach {self.addSubview($0)}
        textLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
