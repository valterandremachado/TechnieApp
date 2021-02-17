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
    lazy var profilePhotoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Profile Photo"
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
    
    lazy var displayNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Display Name"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var displayName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "username"
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Location"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var location: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Baguio City, Philippines"
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var accountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Account"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var accountEmail: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "test@gmail.com"
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var profilePhotoStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profilePhotoLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    lazy var profilePhotoStackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImageView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.withSize(CGSize(width: 40, height: 40))
        return sv
    }()
    
    lazy var displayNameStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [displayNameLabel, displayName])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    lazy var locationStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [locationLabel, location])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    lazy var accountStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [accountLabel, accountEmail])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    // MARK: - Methods
    func setupProfilePhotoStackView() {
        addSubview(profilePhotoStackView)
        
        profilePhotoStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 40))
        
        profilePhotoStackView.addSubview(profilePhotoStackView2)

        NSLayoutConstraint.activate([
            profilePhotoStackView2.centerYAnchor.constraint(equalTo: profilePhotoStackView.centerYAnchor, constant: 0),
            profilePhotoStackView2.trailingAnchor.constraint(equalTo: profilePhotoStackView.trailingAnchor, constant: 0)
        ])
        profilePhotoStackView2.withWidth(40)
        profilePhotoStackView2.withHeight(40)
    }
    
    func setupDisplayNameStackView() {
        addSubview(displayNameStackView)
        displayNameStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 40))
    }
    
    func setupLocationStackView() {
        addSubview(locationStackView)
        locationStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 40))
    }
    
    func setupAccountStackView() {
        addSubview(accountStackView)
        accountStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
