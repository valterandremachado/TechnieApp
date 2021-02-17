//
//  SettingsCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/17/21.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static let cellID = "SettingsCellID"
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "In-App Notification"
        return lbl
    }()
    
    lazy var appVersionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Version"
        return lbl
    }()
    
    lazy var appVersion: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "1.0"
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    lazy var switcherStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, switcher])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    lazy var versionStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [appVersionLabel, appVersion])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Changing selection style
        self.selectionStyle = .none
    }
    
    func setupSwitcherStackView() {
        addSubview(switcherStackView)
        sendSubviewToBack(contentView)
        switcherStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 15))
    }
    
    func setupVersionStackView() {
        addSubview(versionStackView)
        versionStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
