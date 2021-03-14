//
//  AuthCell.swift
//  Technie
//
//  Created by Valter A. Machado on 3/14/21.
//

import UIKit

class AuthCell: UICollectionViewCell {
    
    static let cellID = "AuthCellID"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
