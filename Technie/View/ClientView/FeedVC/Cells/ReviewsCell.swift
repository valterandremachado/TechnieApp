//
//  ReviewsCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/5/21.
//

import UIKit

class ReviewsCell: UITableViewCell {

    static let cellID = "ReviewsCellID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)

    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

class ReviewsCell0: UITableViewCell {

    static let cellID = "ReviewsCell0ID"
    
    // MARK: - Properties
    lazy var workSpeedLabelPlaceHolder: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Work speed".uppercased()
        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 12)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var workSpeedLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "90%"
        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var workQualityLabelPlaceHolder: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Work quality".uppercased()
        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 12)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var workQualityLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "90%"
        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var responseTimeLabelPlaceHolder: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Response time".uppercased()
        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 12)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var responseTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Great"
        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var workSpeedStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [workSpeedLabelPlaceHolder, workSpeedLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillEqually
//        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var workQualityStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [workQualityLabelPlaceHolder, workQualityLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillEqually
//        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var workResponseStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [responseTimeLabelPlaceHolder, responseTimeLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillEqually
//        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var mainStackView: UIStackView = {
        var separatorView1 = UIView()
        separatorView1.translatesAutoresizingMaskIntoConstraints = false
        separatorView1.backgroundColor = .lightGray
        separatorView1.withWidth(0.5)

        var separatorView2 = UIView()
        separatorView2.translatesAutoresizingMaskIntoConstraints = false
        separatorView2.backgroundColor = .lightGray
        separatorView2.withWidth(0.5)
        
        let sv = UIStackView(arrangedSubviews: [workSpeedStackView, separatorView1, workQualityStackView, separatorView2, workResponseStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false

        sv.axis = .horizontal
//        sv.alignment = .center
        sv.spacing = 0
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .red)
//        sv.withHeight(40)

        return sv
    }()
    
    lazy var reliabilityLabelPlaceHolder: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Reliability: ".uppercased()
        lbl.textAlignment = .center
//        lbl.withWidth(100)
        lbl.font = .systemFont(ofSize: 12)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
//        lbl.sizeToFit()
        lbl.clipsToBounds = true
        return lbl
    }()
    
    lazy var reliabilityLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "99%"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 14)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var ratingAndReviewsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "4.5 | 400 services"//★
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 14)
//        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var ratingAndReviewsStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(11))
        var wiredProfileImage = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage?.withAlignmentRectInsets(UIEdgeInsets(top: -1.6, left: 0, bottom: 0, right: 0))

        let sv = UIStackView(arrangedSubviews: [iconIV, ratingAndReviewsLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
        return sv
    }()
    
    lazy var reliabilityLabelPlaceHolderStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [reliabilityLabelPlaceHolder])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .brown)
        sv.withWidth(frame.width/3 - 5)
        return sv
    }()
    
    lazy var reliabilityStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [reliabilityLabelPlaceHolderStackView, ratingAndReviewsStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = -10
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .brown)
//        sv.withWidth(200)
        return sv
    }()
    
   
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    // MARK: - Methods
    func setupViews() {
        [mainStackView].forEach {addSubview($0)}
        mainStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
//        reliabilityStackView.anchor(top: mainStackView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0), size: CGSize(width: frame.width/1.3, height: 0))

    }
    
    func setupViews2() {
        [reliabilityStackView].forEach {addSubview($0)}
        reliabilityStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0), size: CGSize(width: frame.width/1.3, height: 0))    }
    
    // MARK: - Selectors

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
