//
//  FullRankingCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/5/21.
//

import UIKit

class FullRankingCell: UITableViewCell {
    
    static let cellID = "FullRankingCellID"
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
