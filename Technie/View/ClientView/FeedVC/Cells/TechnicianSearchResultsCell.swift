//
//  TechnicianSearchResultsCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/8/21.
//

import UIKit

class TechnicianSearchResultsCell: UITableViewCell {
    static let cellID = "TechnicianSearchResultsCell"
    
    // MARK: - Properties
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.withSize(CGSize(width: 50, height: 50))
        iv.layer.cornerRadius = iv.frame.size.height/2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "technieDummyPhoto")
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.text = " Valter Machado"
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
//        lbl.backgroundColor = .red
        return lbl
    }()
    
    lazy var pricePerHourLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "₱55 per hour                            "
        lbl.textColor = .darkGray//UIColor(named: "LabelPrimaryAppearance")
//        lbl.backgroundColor = .cyan
        return lbl
    }()
    
    lazy var ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = " 5 (40)"//★
        lbl.textColor = .darkGray//UIColor(named: "LabelPrimaryAppearance")

        return lbl
    }()
    
    lazy var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City"
        lbl.textColor = .darkGray//UIColor(named: "LabelPrimaryAppearance")

        return lbl
    }()
    
    lazy var jobTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Electrician, Plumber, Handyman"
        lbl.textColor = .darkGray//UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var locationStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .small)
        var wiredProfileImage = UIImage(systemName: "mappin.and.ellipse", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        iconIV.withWidth(20)

        let sv = UIStackView(arrangedSubviews: [iconIV, locationLabel])
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .fill
        sv.distribution = .fill
//        sv.addBackground(color: .cyan)
        return sv
    }()
    
    lazy var ratingStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
//        iconIV.image = wiredProfileImage
        iconIV.withWidth(20)
        iconIV.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        iconIV.image = wiredProfileImage?.withInset(UIEdgeInsets(top: 0, left: 0, bottom: 0.5, right: 0))
        
        let sv = UIStackView(arrangedSubviews: [iconIV, ratingLabel])
        sv.axis = .horizontal
        sv.spacing = 2
        sv.alignment = .trailing
        sv.distribution = .fill
//        sv.addBackground(color: .brown)

        return sv
    }()
    
//    lazy var skillsStackView: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [jobTitleLabel])
//        sv.axis = .horizontal
//        sv.alignment = .leading
//        sv.distribution = .fill
//        return sv
//    }()
    
    lazy var skillsTagStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "tag.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        iconIV.withWidth(20)
        let sv = UIStackView(arrangedSubviews: [iconIV, jobTitleLabel])
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .leading
        sv.distribution = .fill
//        sv.addBackground(color: .systemPurple)
        return sv
    }()
    
//    lazy var pricePerHourStackView: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [pricePerHourLabel])
//        sv.axis = .horizontal
//        sv.alignment = .leading
//        sv.distribution = .fill
//        return sv
//    }()
    
    lazy var priceStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "pesosign.circle.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        iconIV.withWidth(20)
        
        let sv = UIStackView(arrangedSubviews: [iconIV, pricePerHourLabel])
        sv.axis = .horizontal
        sv.spacing = 5
//        sv.alignment = .leading
        sv.distribution = .fill
//        sv.addBackground(color: .lightGray)
        return sv
    }()
    
    lazy var stackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [locationStackView, ratingStackView])
        sv.axis = .horizontal
        sv.spacing = 10
//        sv.alignment = .leading
        sv.distribution = .fill
//        sv.addBackground(color: .cyan)
        return sv
    }()
    
    lazy var stackView3: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, stackView2, skillsTagStackView, priceStackView])
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackView3])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        return sv
    }()
    
    var rating = 0.0
    var technicianModel: TechnicianModel! {
        didSet {
            rating = technicianModel.clientsSatisfaction?.ratingAvrg ?? 0.0
            
            profileImageView.sd_setImage(with: URL(string: technicianModel.profileInfo.profileImage ?? ""), completed: nil)
            nameLabel.text = technicianModel.profileInfo.name
            jobTitleLabel.text = technicianModel.profileInfo.name
            
            let address = technicianModel.profileInfo.location?.address ?? ""
            let characterToSearch: Character = ","
            if address.contains(characterToSearch) {
                let delimiter = ", "
                let slicedString = technicianModel.profileInfo.location?.address.components(separatedBy: delimiter)[1]
                locationLabel.text = slicedString
            } else {
                locationLabel.text = technicianModel.profileInfo.location?.address ?? ""
            }
            
            pricePerHourLabel.text = "₱\(technicianModel.profileInfo.hourlyRate)"
            if rating != 0 {
                ratingStackView.alpha = 1
                ratingLabel.text = "\(rating) (\(technicianModel.numberOfServices))"
            } else {
                ratingStackView.alpha = 0
            }

            
            // Take all elements of the array then convert it into a plain string
            let skills = technicianModel.profileInfo.skills
            let flatStrings = skills.joined(separator: ", ")
            jobTitleLabel.text = flatStrings
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [mainStackView, profileImageView].forEach {self.addSubview($0)}
        
        profileImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: separatorInset.left, bottom: 0, right: 0))
//        mainStackView.withHeight(160)
        mainStackView.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 8, bottom: 10, right: 20))
        
    }
    
}
