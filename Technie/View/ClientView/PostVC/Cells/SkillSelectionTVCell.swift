//
//  SkillSelectionTVCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/8/21.
//

import UIKit

class SkillSelectionTVCell: UITableViewCell {
    
    static let cellID = "SkillSelectionTVCellID"
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .white
        /// Adding tableView right indicator
        //        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = .gray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SelectedTVCell: UITableViewCell {
    
    static let cellID = "SelectedTVCell"
    
    // MARK: - Properties
    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.font = .boldSystemFont(ofSize: 18)
//        lbl.backgroundColor = .cyan
        lbl.textAlignment = .left
        lbl.text = "PHP"
        return lbl
    }()
    
    lazy var removeSkillBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = UIColor(displayP3Red: 235/255, green: 51/255, blue: 72/255, alpha: 0.2)
//        btn.backgroundColor = .brown
        let modifiedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        btn.setImage(modifiedImage, for: .normal)
//        btn.setTitle("Remove", for: .normal)
//        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
//        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .right
//        btn.isHidden = true
        btn.withWidth(25)
        //        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [customLabel, removeSkillBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
        
        return sv
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .white
        /// Adding tableView right indicator
        //        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = .gray
    }
    
    // MARK: - Methods
    func setupViews() {
        [stackView].forEach {self.contentView.addSubview($0)}
//        stackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: self.separatorInset.left + 5, bottom: 0, right: self.separatorInset.right + 15))
//
        stackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        
//        guard let labelLeading = self.textLabel?.leadingAnchor else { return }
//        guard let labelTrailing = self.textLabel?.trailingAnchor else { return }

//        stackView.anchor(top: self.topAnchor, leading: labelLeading, bottom: self.bottomAnchor, trailing: labelTrailing, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SkillsTVCell: UITableViewCell {
    
    static let cellID = "SkillsTVCell"
    
    // MARK: - Properties
    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.font = .boldSystemFont(ofSize: 18)
//        lbl.backgroundColor = .cyan
        lbl.textAlignment = .left
        lbl.text = "PHP"
        return lbl
    }()
    
    lazy var addSkillBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = UIColor(displayP3Red: 235/255, green: 51/255, blue: 72/255, alpha: 0.2)
//        btn.backgroundColor = .brown
//        btn.setTitle("Add", for: .normal)
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
//        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .right
//        btn.isHidden = true
        btn.withWidth(25)
        //        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [customLabel, addSkillBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .lightGray)
        
        return sv
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .white
        /// Adding tableView right indicator
        //        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = .gray
    }

    
    // MARK: - Methods
    func setupViews() {
        [stackView].forEach { self.contentView.addSubview($0)}
//        stackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: self.separatorInset.left + 5, bottom: 0, right: self.separatorInset.right + 15))
        stackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
//        contentView.bringSubviewToFront(stackView)

//        guard let labelLeading = self.textLabel?.leadingAnchor else { return }
//        guard let labelTrailing = self.textLabel?.trailingAnchor else { return }
//
//        stackView.anchor(top: self.topAnchor, leading: labelLeading, bottom: self.bottomAnchor, trailing: labelTrailing, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
