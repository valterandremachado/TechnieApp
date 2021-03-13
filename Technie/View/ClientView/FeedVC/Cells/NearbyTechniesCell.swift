//
//  FeedCell.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit
import LBTATools

class NearbyTechniesCell: UICollectionViewCell {
    
    // MARK: - Properties
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.withSize(CGSize(width: 50, height: 50))
        iv.layer.cornerRadius = iv.frame.size.height/2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
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
   
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        
        let screenSize = UIScreen.main.bounds
//        view.withSize(CGSize(width: screenSize.width - 10, height: 1))
        view.withHeight(0.5)
        return view
    }()
    
    var rating = 0.0
    var technicianModel: TechnicianModel! {
        didSet {
            rating = technicianModel.clientsSatisfaction?.ratingAvrg ?? 0.0
            
            profileImageView.sd_setImage(with: URL(string: technicianModel.profileInfo.profileImage ?? ""), completed: nil)
            nameLabel.text = technicianModel.profileInfo.name
            jobTitleLabel.text = technicianModel.profileInfo.name
            locationLabel.text = technicianModel.profileInfo.location
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
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .darkGray
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [mainStackView, profileImageView, separatorView].forEach {self.addSubview($0)}
        
//        saveBtn.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5))
        separatorView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: -16, left: 5, bottom: 0, right: 5))
        
        profileImageView.anchor(top: separatorView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 0))
//        mainStackView.withHeight(160)
        mainStackView.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 20))

//        separatorView.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5))
//        nameLabel.text = "technician1 technician1"
//        jobTitleLabel.text = "technician1 technician1"
//        locationLabel.text = "technican1"
//        pricePerHourLabel.text = "150.0"
//        ratingLabel.text = "4.5(267) 4.5(267)"
        
    }
    
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - NearbyTechniesCellPreviews
import SwiftUI

struct NearbyTechniesCellPreviews: PreviewProvider {
   
    static var previews: some View {
        let cell = NearbyTechniesCell()
        return cell.liveView
    }
}
