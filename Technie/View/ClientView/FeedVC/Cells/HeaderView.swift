//
//  Header.swift
//  Technie
//
//  Created by Valter A. Machado on 12/17/20.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    lazy var sectionTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.font = .systemFont(ofSize: 15)
//        lbl.textColor = .systemGray
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
        btn.isEnabled = false
        //        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        btn.addTarget(self, action: #selector(seeAllBtnPressed), for: .touchUpInside)
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
    
    var headerDynamicLeadingAnchor: NSLayoutConstraint!
    var userPostModel: [PostModel] = []
    var technieRank: [TechnicianModel] = []

    var rank: [TechnicianModel] = [] {
        didSet {
            technieRank = rank
            if technieRank.count != 0 {
                fetchUserPosts()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView(){
        self.addSubview(stackView)
        
        stackView.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14))
        
        headerDynamicLeadingAnchor = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14)
        headerDynamicLeadingAnchor.isActive = true
    }
    
    
    fileprivate func fetchUserPosts()  {
        DatabaseManager.shared.getAllClientPosts(completion: { [self] result in
            switch result {
            case .success(let userPosts):
                userPostModel = userPosts
                self.seeAllBtn.isEnabled = true
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @objc func seeAllBtnPressed(sender: UIButton) {
        let vc = FullRankingVC()
        vc.technieRank = technieRank
        vc.userPostModel = userPostModel
//        navigationController?.pushViewController(vc, animated: true)
        guard let presentVCFromCell = UIApplication.cellDidPresentViewController() else { return }
        presentVCFromCell.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
