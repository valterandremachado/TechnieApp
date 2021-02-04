//
//  AboutCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/4/21.
//

import UIKit

class AboutCell: UITableViewCell {

    static let cellID = "AboutCellID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)

    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
