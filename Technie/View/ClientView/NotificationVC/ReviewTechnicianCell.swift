//
//  ReviewTechnicianCell.swift
//  Technie
//
//  Created by Valter A. Machado on 3/4/21.
//

import UIKit

class ReviewTechnicianCell: UITableViewCell {
    static let cellID = "ReviewTechnicianCellID"
    
    let items = ["Poor", "Fair", "Good", "Excellent"]
    // MARK: - Properties
    lazy var segment: UISegmentedControl = {
        let seg = UISegmentedControl(items: items)
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = .systemGray4
        seg.withHeight(35)
//        seg.frame = CGRect(x: 35, y: 200, width: 250, height: 50)
//        seg.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
//        self.addSubview(seg)
        return seg
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
        self.selectionStyle = .none
        setupViews()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setupViews() {
        [segment].forEach {contentView.addSubview($0)}
        segment.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
    
    // MARK: - Methods

}
