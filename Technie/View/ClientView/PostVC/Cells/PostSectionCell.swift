//
//  PostSectionCell.swift
//  Technie
//
//  Created by Valter A. Machado on 12/27/20.
//

import UIKit

class PostSectionCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .blue
        
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
