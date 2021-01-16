//
//  JobDetailCVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/16/21.
//

import UIKit

class JobDetailCVCell: UICollectionViewCell {
    static let cellID = "JobDetailCVCellID"
    
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
    
    lazy var jobPostTimeTrackerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "3 hours ago"
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var locationIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var jobLocationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Location"
        lbl.textAlignment = .right
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var locationStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [locationIcon, jobLocationLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.addBackground(color: .lightGray)
        return sv
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
    
    lazy var jobFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [jobField, jobFieldLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var budgetAndLocationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [budgetStack, jobFieldStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.spacing = 2
        stack.distribution = .fillEqually
//        stack.addBackground(color: .yellow)
        stack.withHeight(40)
        return stack
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleAndLikeBtnStack, jobDescriptionLabel, budgetAndLocationStack, jobPostTimeTrackerLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
//        stack.spacing = 2
        stack.distribution = .fillProportionally
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray3
//        setupViews()
    }
    
    // MARK: - Methods
    func setupViewsOnItem0() {
        // Customize Cell
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true

        [jobTitleLabel].forEach {self.addSubview($0)}
        jobTitleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
    
    func setupViewsOnItem1() {
        [jobDescriptionLabel, locationStackView].forEach {self.addSubview($0)}
        
        jobDescriptionLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        
        locationStackView.anchor(top: jobDescriptionLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
    }
    
    func setupViewsOnItem2() {
        [].forEach {self.addSubview($0)}

    }
    
    func setupViewsOnItem3() {
        [].forEach {self.addSubview($0)}

    }
    
    func setupViewsOnItem4() {
        [].forEach {self.addSubview($0)}

    }
    
    func setupViewsOnItem5() {
        [].forEach {self.addSubview($0)}

    }
    
    func setupViewsOnItem6() {
        [].forEach {self.addSubview($0)}

    }
    
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
