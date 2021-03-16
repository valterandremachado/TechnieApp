//
//  ChatInfoSectionOneCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/28/21.
//

import UIKit

class ChatInfoSectionOneCell: UITableViewCell {
    
    static let cellID = "ChatInfoSectionOneCellID"
    
    lazy var profileImageView: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        iv.roundedImage()
//        iv.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        //        iv.sizeToFit()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
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
    
    lazy var emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "user@gmail.com"
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 14)
//        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var nameAndEmailStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = -2
        sv.distribution = .equalSpacing
        return sv
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setupViewsForCell() {
        [profileImageView, nameAndEmailStackView].forEach {addSubview($0)}
                
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 75),
            profileImageView.heightAnchor.constraint(equalToConstant: 75),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ])
        
        nameAndEmailStackView.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10), size: CGSize(width: 0, height: 0))
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChatInfoSectionTwoCell: UITableViewCell {
    
    static let cellID = "ChatInfoSectionTwoCellID"
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChatInfoSectionThreeCell: UITableViewCell {
    
    static let cellID = "ChatInfoSectionThreeCellID"
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
