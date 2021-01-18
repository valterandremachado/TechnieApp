//
//  MessageTVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/18/21.
//

import UIKit

class MessageTVCell: UITableViewCell {
    
    static let cellID = "MessageTVCellID"
    
    // MARK: - Properties
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        backgroundColor = .yellow
    }
    
    func setupViews() {
//        [jobTitleLabel].forEach { self.addSubview($0)}
//        jobTitleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
