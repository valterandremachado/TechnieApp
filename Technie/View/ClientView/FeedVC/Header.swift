//
//  Header.swift
//  Technie
//
//  Created by Valter A. Machado on 12/17/20.
//

import UIKit

class Header: UICollectionReusableView {

    lazy var sectionTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 20)

        return lbl
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [sectionTitle])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        //        sv.alignment = .center
        sv.distribution = .equalCentering
//        sv.addBackground(color: .lightGray)
        
        return sv
    }()
    
   override init(frame: CGRect) {
       super.init(frame: frame)
//       self.backgroundColor = UIColor.purple
        setupView()
    }
    
    fileprivate func setupView(){
        self.addSubview(stackView)
        
        stackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)

    }
}
