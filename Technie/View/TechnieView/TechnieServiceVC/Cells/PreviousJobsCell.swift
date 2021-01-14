//
//  PreviousJobs.swift
//  Technie
//
//  Created by Valter A. Machado on 1/14/21.
//

import UIKit

class PreviousJobsTVCell: UITableViewCell {
    
    static let cellID = "PreviousJobsTVCellID"
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .white
        /// Adding tableView right indicator
        //        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = .gray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
