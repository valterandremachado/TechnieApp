//
//  TechineProfileTVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/14/21.
//

import UIKit

class TechineProfileTVCell: UITableViewCell {
    
    static let cellID = "TechineProfileTVCellID"
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .white
        /// Adding tableView right indicator
        //        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = .gray
//        print(imageView?.frame.size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
