//
//  ReviewsCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/5/21.
//

import UIKit
import Cosmos

class ReviewsCell: UITableViewCell {

    static let cellID = "ReviewsCellID"
    
    // MARK: - Properties
    lazy var serviceNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Fix an old TV "
        lbl.textAlignment = .left
//        lbl.backgroundColor = .green
        //        lbl.withHeight(25)
//        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var serviceDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "April 2021"
        lbl.textAlignment = .right
        lbl.withWidth(80)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray //UIColor(named: "LabelPrimaryAppearance")
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()

    lazy var reviewCommentLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Great work from a great technician. Great work from a great technician. Great work from a great technician. Great work from a great technician."
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        
        return lbl
    }()
    
    lazy var clientNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter A. Machado - 2 days ago".lowercased()
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray//UIColor(named: "LabelPrimaryAppearance")
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    lazy var ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "4.5"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
//        lbl.font = .systemFont(ofSize: 13)
//        lbl.backgroundColor = .systemPink
//        lbl.clipsToBounds = true
//        lbl.layer.cornerRadius = 5
        lbl.numberOfLines = 0
//        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var serviceNameAndDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [serviceNameLabel, serviceDateLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
//        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fill
//        sv.addBackground(color: .cyan)
        
        sv.withWidth(frame.width)
//        sv.withHeight(20)
        return sv
    }()
    
    lazy var ratingView: CosmosView = {
        let view = CosmosView()
//        view.backgroundColor = .red
        view.settings.filledColor = .systemPink
//        view.settings.emptyColor = .systemPink
//        view.settings.emptyImage = UIImage(systemName: "star")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
//        view.settings.filledImage = UIImage(systemName: "star.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        view.settings.updateOnTouch = false
        view.settings.starMargin = -1
        view.settings.starSize = 17
        view.settings.fillMode = .half
        view.withWidth(80)
//        view.didFinishTouchingCosmos = { rating in
//            print("rating: \(rating)")
//        }

        return view
    }()
    
    lazy var ratingWithIconStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold, scale: .large)
        var wiredProfileImage = UIImage(named: "rating4", in: nil, with: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFill
        iconIV.withWidth(70)
//        iconIV.backgroundColor = .brown
        iconIV.image = wiredProfileImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let sv = UIStackView(arrangedSubviews: [ratingView, ratingLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
        sv.withWidth(frame.width - frame.width/3)
        sv.withHeight(17)
        return sv
    }()
    
    lazy var technicianInfoLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [serviceNameAndDateStackView, ratingWithIconStackView, reviewCommentLabel, clientNameLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
//        sv.distribution = .fillProportionally
//        sv.addBackground(color: .brown)
//        sv.withHeight(150)
        return sv
    }()
    
    var reviews: Review! {
        didSet {
            let delimiter = "at"
            let slicedString = reviews.dateOfHiring.components(separatedBy: delimiter)[0]
            serviceNameLabel.text = reviews.jobTitle
            ratingLabel.text = "\(reviews.rating)"
            reviewCommentLabel.text = reviews.reviewComment
            serviceDateLabel.text = slicedString
            clientNameLabel.text = "\(reviews.clientName) - \(calculateTimeFrame(initialTime: reviews.dateOfReview))".lowercased()
            ratingView.rating = reviews.rating
        }
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)

    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    

    func setupViews() {
        [technicianInfoLabelStackView].forEach {addSubview($0)}
        technicianInfoLabelStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: separatorInset.left, bottom: 15, right: 0))
    }
}

class ProficiencyReviewCell: UITableViewCell {

    static let cellID = "ProficiencyReviewCellID"
    
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
        lbl.font = .systemFont(ofSize: 12)
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
        lbl.font = .systemFont(ofSize: 12)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var responseTimeLabelPlaceHolder: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "response time".uppercased()
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
        lbl.font = .systemFont(ofSize: 12)
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
        lbl.text = " 4.5 | 400 services"//★
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
    
    lazy var responseTimeStackView: UIStackView = {
        responseTimeLabelPlaceHolder.textAlignment = .left
//        responseTimeLabelPlaceHolder.backgroundColor = .red
//        responseTimeLabelPlaceHolder.withWidth(150)
//        responseTimeLabel.withWidth(50)
        responseTimeLabel.textAlignment = .left
        responseTimeLabelPlaceHolder.text = "response time:".uppercased()
        responseTimeLabel.text = "Great".uppercased()
        let sv = UIStackView(arrangedSubviews: [responseTimeLabelPlaceHolder, responseTimeLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .brown)
//        sv.withWidth(200)
        sv.withWidth(frame.width/1.4 - 25)
        return sv
    }()
    
    let items = ["Poor", "Fair", "Good", "Excellent"]

    var satisfactionAvrg: ClientsSatisfaction! {
        didSet {
            workSpeedLabel.text = "\(items[Int(satisfactionAvrg.workSpeedAvrg.rounded(.toNearestOrAwayFromZero))])"
            workQualityLabel.text = "\(items[Int(satisfactionAvrg.workQualityAvrg.rounded(.toNearestOrAwayFromZero))])"
            responseTimeLabel.text = "\(items[Int(satisfactionAvrg.responseTimeAvrg.rounded(.toNearestOrAwayFromZero))])"
        }
    }
    
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
    
    func setupReliabilityStackView() {
        [reliabilityStackView].forEach {addSubview($0)}
        reliabilityStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0))
        //frame.width/1.3
    }
    
    func setupResponseTimeStackView() {
        [responseTimeStackView].forEach {addSubview($0)}
        responseTimeStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 10, left: 15, bottom: 5, right: 0))
        //frame.width/1.3
    }
    
    // MARK: - Selectors

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
