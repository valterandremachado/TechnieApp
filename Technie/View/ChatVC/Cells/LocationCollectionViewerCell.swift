//
//  LocationCollectionViewerVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/29/21.
//

import UIKit

class LocationCollectionViewerCell: UITableViewCell {
    
    static let cellID = "LocationCollectionViewerCellID"
    
    // MARK: - Properties
    
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
//    func setupViews() {
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
