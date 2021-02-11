//
//  reviewCollectionViewCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/12/21.
//

import UIKit

class ReviewCollectionViewTopCell: UICollectionViewCell {
    
    static let cellID = "ReviewCollectionViewTopCellID"
    
    lazy var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .darkGray
//        setupViews()
        addSubview(customView)
        customView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        customView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        customView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReviewCollectionViewBottomCell: UICollectionViewCell {
    
    static let cellID = "ReviewCollectionViewBottomCellID"
    
    lazy var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .darkGray
//        setupViews()
        addSubview(customView)
        customView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        customView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReviewCollectionViewCellHeaderView: UICollectionReusableView {
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let cellID = "ReviewCollectionViewCellHeaderViewID"
    override init(frame: CGRect) {
        super.init(frame: frame)
        //       self.backgroundColor = UIColor.purple
        addSubview(contentView)
        contentView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
