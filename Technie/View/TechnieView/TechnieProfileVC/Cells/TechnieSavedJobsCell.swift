//
//  TechnieSavedJobsCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/18/21.
//

import UIKit

class TechnieSavedJobsCell: UITableViewCell {
    static let cellID = "TechnieSavedJobsCellID"
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        accessoryType = .none
//        selectionStyle = .none
    }
    
    // MARK: - Methods
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
