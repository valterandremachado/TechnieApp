//
//  RecommendationCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/9/21.
//

import UIKit
import Cosmos
import MapKit

class RecommendationCell: UITableViewCell {
    
    static let cellID = "RecommendationCellID"

    // MARK: - Properties
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter A. Machado"
        lbl.textAlignment = .center
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "3km away from your place"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 13)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var proficiencyLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Proficiency: 90%"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 13)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var ratingAndServicesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "4.5 (40) | 400 services"
//        lbl.textAlignment = .right
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 13)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var skillsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Plumber, handyman"
//        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .systemFont(ofSize: 13)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.withSize(CGSize(width: 60, height: 60))
        iv.layer.cornerRadius = 15//iv.frame.size.height/2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        iv.image = UIImage(named: "technieDummyPhoto")
        return iv
    }()
    
    lazy var distanceWithIconStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .small)
        var wiredProfileImage = UIImage(named: "distance", in: nil, with: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.withWidth(13)
//        iconIV.backgroundColor = .brown
        iconIV.image = wiredProfileImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let sv = UIStackView(arrangedSubviews: [iconIV, distanceLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
        sv.withWidth(frame.width - frame.width/2.5)
        sv.withHeight(20)
        return sv
    }()
    
    lazy var ratingView: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue
        view.settings.filledColor = .systemPink
//        view.settings.emptyColor = .systemPink
//        view.settings.emptyImage = UIImage(systemName: "star")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
//        view.settings.filledImage = UIImage(systemName: "star.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        view.settings.updateOnTouch = false
        view.settings.starMargin = -1
        view.settings.starSize = 16
        view.settings.fillMode = .half
        view.withWidth(75)
//        view.rating = 5
        view.bounds = view.frame.insetBy(dx: 0.0, dy: -2)

//        view.frame = .init(x: 0, y: -2.5, width: 0, height: 0)
//        view.didFinishTouchingCosmos = { rating in
//            print("rating: \(rating)")
//        }
        return view
    }()
    
    lazy var ratingAndServicesWithIconStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        var wiredProfileImage = UIImage(named: "rating4", in: nil, with: config)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFill
        iconIV.withWidth(50)
//        iconIV.backgroundColor = .brown
        iconIV.image = wiredProfileImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let sv = UIStackView(arrangedSubviews: [ratingView, ratingAndServicesLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fill
//        sv.addBackground(color: .cyan)
        sv.withWidth(frame.width - frame.width/4.5)
        sv.withHeight(20)
        sv.subviews[0].layoutMargins = .init(top: 2.5, left: 0, bottom: 0, right: 0)

        return sv
    }()
    
    lazy var skillsWithIconStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .small)
        var wiredProfileImage = UIImage(systemName: "tag.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)

        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.withWidth(13)
//        iconIV.backgroundColor = .brown
        iconIV.image = wiredProfileImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let sv = UIStackView(arrangedSubviews: [iconIV, skillsLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
        sv.withWidth(frame.width - 50)
        sv.withHeight(20)
        return sv
    }()
    
    lazy var proficiencyWithIconStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        var wiredProfileImage = UIImage(named: "proficiency4", in: nil, with: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.withWidth(14)
//        iconIV.backgroundColor = .brown
        iconIV.image = wiredProfileImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let sv = UIStackView(arrangedSubviews: [iconIV, proficiencyLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
        sv.withWidth(frame.width - frame.width/2.5)
        sv.withHeight(20)
        return sv
    }()
    
    lazy var technicianInfoLabelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, distanceWithIconStackView, ratingAndServicesWithIconStackView, skillsWithIconStackView, proficiencyWithIconStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .leading
//        sv.distribution = .fillProportionally
//        sv.addBackground(color: .brown)
//        sv.withHeight(150)
        return sv
    }()
    
    let proficiencyInDecimal: [Double] = [0.25, 0.50, 0.75, 1.0]
    var workSpeed = 0
    var workQuality = 0
    var responseTime = 0
    
    var recommendedTechniciansModel: TechnicianModel! {
        didSet {
            guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }

            workSpeed = Int(recommendedTechniciansModel.clientsSatisfaction?.workSpeedAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            workQuality = Int(recommendedTechniciansModel.clientsSatisfaction?.workQualityAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            responseTime = Int(recommendedTechniciansModel.clientsSatisfaction?.responseTimeAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            
            let sum = proficiencyInDecimal[workSpeed] + proficiencyInDecimal[workQuality] + proficiencyInDecimal[responseTime]
            let proficiencyInPercentage = "\(String(format:"%.0f", sum/3 * 100))%"
            let numberOfServices = recommendedTechniciansModel.numberOfServices
            var label = ""
            numberOfServices == 1 ? (label = "Service") : (label = "Services")
            
            profileImageView.sd_setImage(with: URL(string: recommendedTechniciansModel.profileInfo.profileImage ?? ""), completed: nil)
            nameLabel.text = recommendedTechniciansModel.profileInfo.name
            ratingView.rating = recommendedTechniciansModel.clientsSatisfaction?.ratingAvrg ?? 0.0

            proficiencyLabel.text = "Proficiency: " + proficiencyInPercentage
            ratingAndServicesLabel.text = "\(recommendedTechniciansModel.clientsSatisfaction?.ratingAvrg ?? 0.0) | \(numberOfServices) \(label)"
            
            // Take all elements of the array then convert it into a plain string
            let skills = recommendedTechniciansModel.profileInfo.skills
            let flatString = skills.joined(separator: ", ")
            skillsLabel.text = flatString
            
            let clientLat = getUsersPersistedInfo.location.lat
            let clientLong = getUsersPersistedInfo.location.long
            let technicianLat = recommendedTechniciansModel.profileInfo.location?.lat ?? 0.0
            let technicianLong = recommendedTechniciansModel.profileInfo.location?.long ?? 0.0
            
            // Client location
            let clientLocation = CLLocation(latitude: clientLat, longitude: clientLong)
            //  Technician location
            let technicianLocation = CLLocation(latitude: technicianLat, longitude: technicianLong)
            //Finding my distance to my next destination (in km)
            let distance = clientLocation.distance(from: technicianLocation) / 1000
            distanceLabel.text = "\(String(format: "%.01f km", distance)) away from your place"
        }
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setupViews()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    // MARK: - Methods
    func setupViews() {
        [technicianInfoLabelStackView, profileImageView].forEach {addSubview($0)}
        
        profileImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: separatorInset.left, bottom: 0, right: 0))

        technicianInfoLabelStackView.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 0))
    }
}
