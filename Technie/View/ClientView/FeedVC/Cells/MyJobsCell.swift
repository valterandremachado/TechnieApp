//
//  MyJobsCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/26/21.
//

import UIKit

class MyJobsCell: UITableViewCell {

    static let cellID = "MyJobsCellID"
    
    
    var userPostModel: PostModel! {
        didSet {
            textLabel?.text = userPostModel.title
            detailTextLabel?.text = calculateTimeFrame(initialTime: userPostModel.dateTime)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        detailTextLabel?.textColor = .systemGray
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
