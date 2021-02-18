//
//  TechnieAccountCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/18/21.
//

import UIKit

class TechnieAccountCell: UITableViewCell {
    static let cellID = "TechnieAccountCellID"
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = "Display Name"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = "username"
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .systemGray
        return lbl
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
        accessoryType = .none
        selectionStyle = .none
        setupViews()
    }
    
    // MARK: - Methods
//    var dynamicTrailing: NSLayoutConstraint?
    func setupViews() {
        addSubview(mainStackView)
        mainStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 40))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
