//
//  FullRankingCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/5/21.
//

import UIKit

class FullRankingCell: UICollectionViewCell {
    
    static let cellID = "FullRankingCellID"
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray3
//        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
