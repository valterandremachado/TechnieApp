//
//  searchResultCell.swift
//  Technie
//
//  Created by Valter A. Machado on 12/19/20.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
        
    // MARK: - Properties
    lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 20)
//        lbl.backgroundColor = .red
        lbl.text = "Technician"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [title])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .lightGray)
        
        return sv
    }()
    
    var dynamicWidth: NSLayoutConstraint!
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .darkGray
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        // Customize Cell
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        [stackView].forEach {self.addSubview($0)}
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            stackView.topAnchor.constraint(equalTo: self.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

            stackView.heightAnchor.constraint(equalToConstant: 100),
//            stackView.widthAnchor.constraint(equalToConstant: self.frame.width)

        ])
        dynamicWidth = stackView.widthAnchor.constraint(equalToConstant: 0)
        dynamicWidth.isActive = true

    }
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
