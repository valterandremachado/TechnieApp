//
//  ExpertiseCell.swift
//  Technie
//
//  Created by Valter A. Machado on 3/11/21.
//

import UIKit

class ExpertiseCell: UITableViewCell {
    
    static let cellID = "ExpertiseCellID"
    
    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    lazy var removeSkillBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let modifiedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        btn.setImage(modifiedImage, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.withWidth(25)
        return btn
    }()
        
    lazy var removeExpertisetackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [customLabel, removeSkillBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fill
        return sv
    }()
    
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
   
    
    func setupMyExpertiseViews() {
        [removeExpertisetackView].forEach { self.contentView.addSubview($0)}
        
        removeExpertisetackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
}

class SuggestedExpertiseCell: UITableViewCell {
    static let cellID = "SuggestedExpertiseCellID"

    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    lazy var addSkillBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.withWidth(25)
        return btn
    }()
    
    lazy var addExpertiseStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [customLabel, addSkillBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fill
//        sv.addBackground(color: .lightGray)
        
        return sv
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    func setupSuggestedExpertiseViews() {
        [addExpertiseStackView].forEach {self.contentView.addSubview($0)}
        
        addExpertiseStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
}
