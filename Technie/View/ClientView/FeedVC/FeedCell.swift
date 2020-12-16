//
//  FeedCell.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit

class FeedCell: UICollectionViewCell {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
