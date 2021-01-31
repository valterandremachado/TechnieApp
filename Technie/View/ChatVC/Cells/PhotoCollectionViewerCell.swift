//
//  PhotoCollectionCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/29/21.
//

import UIKit

class PhotoCollectionViewerCell: UICollectionViewCell {
        
    static let cellID = "PhotoCollectionViewerCellID"
    // MARK: - Properties
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .darkGray
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
