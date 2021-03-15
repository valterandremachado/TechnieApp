//
//  TechnicianContinueCell.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit

class TechnicianContinueCell: UITableViewCell {

    static let cellID = "TechnicianContinueCellID"
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    

}
