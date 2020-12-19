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
//        lbl.backgroundColor = .cyan
        return lbl
    }()
    
    lazy var seeAllBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = UIColor(displayP3Red: 235/255, green: 51/255, blue: 72/255, alpha: 0.2)
//        btn.backgroundColor = .brown
        btn.setTitle("See All", for: .normal)
//        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .right
        btn.isHidden = true
        btn.withWidth(70)
        //        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [sectionTitle, seeAllBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
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
