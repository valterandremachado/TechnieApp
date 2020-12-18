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
//        iv.backgroundColor = .blue
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
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
//        lbl.backgroundColor = .cyan
        return lbl
    }()
    
    lazy var ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = " 5 (40)"//★
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")

        return lbl
    }()
    
    lazy var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City"
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")

        return lbl
    }()
    
    lazy var jobTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Electrician, Plumber, Handyman"
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var locationStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "location.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        
        let sv = UIStackView(arrangedSubviews: [iconIV, locationLabel])
        sv.axis = .horizontal
        sv.spacing = 2
//        sv.alignment = .fill
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .red)
        return sv
    }()
    
    lazy var ratingStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        
        let sv = UIStackView(arrangedSubviews: [iconIV, ratingLabel])
        sv.axis = .horizontal
        sv.spacing = 2
        sv.alignment = .leading
        sv.distribution = .fill
//        sv.addBackground(color: .red)
        return sv
    }()
    
    lazy var skillsTagStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "tag.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        
        let sv = UIStackView(arrangedSubviews: [iconIV, jobTitleLabel])
        sv.axis = .horizontal
        sv.spacing = 2
//        sv.alignment = .fill
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .red)
        return sv
    }()
    
    lazy var priceStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "dollarsign.circle.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
//        iconIV.withWidth(15)
        
        let sv = UIStackView(arrangedSubviews: [iconIV, pricePerHourLabel])
        sv.axis = .horizontal
        sv.spacing = 2
//        sv.alignment = .leading
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .red)
        return sv
    }()
    
    lazy var stackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [locationStackView, ratingStackView])
        sv.axis = .horizontal
        sv.spacing = 10
//        sv.alignment = .leading
        sv.distribution = .fillEqually
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
    
    lazy var saveBtn: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(20))
        var image = UIImage(systemName: "bookmark", withConfiguration: config)?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("Save", for: .normal)
        btn.setImage(image, for: .normal)
//        btn.backgroundColor = .red
//        btn.withSize(CGSize(width: 50, height: 50))
        return btn
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        
        let screenSize = UIScreen.main.bounds
        view.withSize(CGSize(width: screenSize.width - 10, height: 1))
        return view
    }()
    
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
        
        profileImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 0))
//        mainStackView.withHeight(160)
        mainStackView.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 0))

        separatorView.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
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
