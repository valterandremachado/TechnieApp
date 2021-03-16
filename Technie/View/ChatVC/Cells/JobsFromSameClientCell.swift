//
//  JobsFromSameClientCell.swift
//  Technie
//
//  Created by Valter A. Machado on 3/16/21.
//

import UIKit

class JobsFromSameClientCell: UITableViewCell {
    
    static let cellID = "JobsFromSameClientCellID"
    
    // MARK: - Properties
    var userPostModel: PostModel! {
        didSet {
            textLabel?.text = userPostModel.title
            detailTextLabel?.text = "Hired \(calculateTimeFrame(initialTime: userPostModel.hiringStatus?.date ?? ""))"
        }
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.textColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
