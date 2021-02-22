//
//  PostFormCell.swift
//  Technie
//
//  Created by Valter A. Machado on 12/29/20.
//

import UIKit

// MARK: - PostFormCell
class PostFormCell: UITableViewCell {

    
    // MARK: - Properties
    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12)
//        lbl.backgroundColor = .cyan
        lbl.textAlignment = .right
        lbl.text = "Max size is 30 MB"
        return lbl
    }()
    
    lazy var attachFileBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = .brown
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.setTitle("Attach File", for: .normal)
        btn.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
        btn.contentHorizontalAlignment = .left
        btn.withWidth(110)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [attachFileBtn, customLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .lightGray)
        
        return sv
    }()
    
    lazy var customImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    lazy var customLabel2: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 11.3)
//        lbl.backgroundColor = .cyan
        lbl.textAlignment = .left
        return lbl
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
        backgroundColor = .yellow
//        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func setupViews() {
        [stackView].forEach {addSubview($0)}
        stackView.anchor(top: contentView.topAnchor, leading: contentView.safeAreaLayoutGuide.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: self.separatorInset.left, bottom: 0, right: self.separatorInset.right + 15))
    }
    
    func setupNewViews() {
        [customImageView, customLabel2].forEach {addSubview($0)}
        
        customImageView.anchor(top: self.topAnchor, leading: textLabel?.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        
        customLabel2.anchor(top: customImageView.topAnchor, leading: customImageView.trailingAnchor, bottom: customImageView.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
    }
    
    // MARK: - Selectors

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - PostFormProjectTypeCell
class PostFormProjectTypeCell: UITableViewCell {
    static var cellID = "PostFormProjectTypeCell"
    
    let items = ["Long Term", "Short Term"]
    // MARK: - Properties
    lazy var projectTypeSwitcher: UISegmentedControl = {
        let seg = UISegmentedControl(items: items)
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = .systemGray4
        
//        seg.frame = CGRect(x: 35, y: 200, width: 250, height: 50)
//        seg.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
//        self.addSubview(seg)
        return seg
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .white
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
//        backgroundColor = .gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func setupViews() {
        [projectTypeSwitcher].forEach {contentView.addSubview($0)}
//        self.bringSubviewToFront(projectTypeSwitcher)
        NSLayoutConstraint.activate([
            projectTypeSwitcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            projectTypeSwitcher.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            projectTypeSwitcher.heightAnchor.constraint(equalToConstant: 35),
//            projectTypeSwitcher.widthAnchor.constraint(equalToConstant: 100),
            projectTypeSwitcher.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            projectTypeSwitcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
        ])
//        projectTypeSwitcher.anchor(top: contentView.topAnchor, leading: contentView.safeAreaLayoutGuide.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: self.separatorInset.left + 5, bottom: 0, right: self.separatorInset.right + 15))
    }
    // MARK: - Selectors
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
            switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                break
            case 1:
                break
            default:
                break
            }
        }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - PostFormBudgetCell
class PostFormBudgetCell: UITableViewCell {
    static var cellID = "PostFormBudgetCell"

    // MARK: - Properties
    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
//        lbl.backgroundColor = .cyan
        lbl.textAlignment = .right
        lbl.text = "PHP"
        return lbl
    }()
    
    lazy var budgetBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = UIColor(displayP3Red: 235/255, green: 51/255, blue: 72/255, alpha: 0.2)
//        btn.backgroundColor = .brown
        btn.setTitle("₱200 - ₱800 / hour", for: .normal)
//        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
//        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .left
//        btn.isHidden = true
//        btn.withWidth(80)
        //        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [budgetBtn, customLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillEqually
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
        self.selectionStyle = .none
//        backgroundColor = .green

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func setupViews() {
        [stackView].forEach {contentView.addSubview($0)}
        stackView.anchor(top: contentView.topAnchor, leading: contentView.safeAreaLayoutGuide.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: self.separatorInset.left + 5, bottom: 0, right: self.separatorInset.right + 15))
    }
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - PostFormSkillCell
class PostFormSkillCell: UITableViewCell {
    static var cellID = "PostFormSkillCell"
    
    var addSkillsBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = .brown
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.setTitle("Add Skills", for: .normal)
        btn.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
        btn.contentHorizontalAlignment = .left
        btn.isHidden = true
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .white
        /// Adding tableView right indicator
        //        self.accessoryType = .disclosureIndicator
        /// Changing selection style
        self.selectionStyle = .none
        backgroundColor = .white
        
        //        self.layer.cornerRadius = 15
        //        self.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupViews() {
        [addSkillsBtn].forEach {self.contentView.addSubview($0)}
        addSkillsBtn.isHidden = false
        addSkillsBtn.anchor(top: self.contentView.topAnchor, leading: self.contentView.safeAreaLayoutGuide.leadingAnchor, bottom: self.contentView.bottomAnchor, trailing: self.contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: self.separatorInset.left, bottom: 0, right: self.separatorInset.right + 15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
