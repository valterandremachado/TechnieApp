//
//  FeedCell2.swift
//  Technie
//
//  Created by Valter A. Machado on 12/17/20.
//

import UIKit

class FeedCell2: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        backgroundColor = .systemPink
//        tintColor = .blue
//        textLabel?.textColor = .black
//        detailTextLabel?.textColor = .black
        
        /// Adding tableView right indicator
        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
