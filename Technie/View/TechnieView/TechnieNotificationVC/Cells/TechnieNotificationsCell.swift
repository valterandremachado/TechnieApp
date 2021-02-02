//
//  TechnieNotificationsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/2/21.
//

import UIKit

class TechnieNotificationsCell: UITableViewCell {
    
    static let cellID = "TechnieNotificationsCellID"
    
    // MARK: - Properties
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Changing selection style
//        self.selectionStyle = .none
    }
    
    func setupViews() {
       
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
