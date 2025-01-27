//
//  EditProfileCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/17/21.
//

import UIKit

class EditProfileCell: UITableViewCell {
    
    static let cellID = "EditProfileCellID"
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var profilePhotoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        setupViewsTwo()
    }
    
    // MARK: - Methods
    func setupViewsOne() {
        addSubview(profilePhotoLabel)
        
        profilePhotoLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 40))
        
        profilePhotoLabel.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: profilePhotoLabel.centerYAnchor, constant: 0),
            profileImageView.trailingAnchor.constraint(equalTo: profilePhotoLabel.trailingAnchor, constant: 0)
        ])
        profileImageView.withWidth(40)
        profileImageView.withHeight(40)
    }
    
    func setupViewsTwo() {
        addSubview(mainStackView)
        mainStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 40))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
