//
//  ClientNotificationCell.swift
//  Technie
//
//  Created by Valter A. Machado on 3/1/21.
//

import UIKit
import FirebaseDatabase

class ClientNotificationCell: UITableViewCell {
    
    static let cellID = "ClientNotificationCellID"
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Notification Title"
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.isHidden = true
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Notification Description" //You can start a conversation with the post owner now
        lbl.numberOfLines = 0
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Feb 12"
        lbl.textColor = .systemGray2
        lbl.font = .systemFont(ofSize: 13)
        return lbl
    }()
    
    lazy var imageIconView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "bell.fill")
        return icon
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 5
        return sv
    }()
    
    var userNotification: ClientNotificationModel! {
        didSet {
            descriptionLabel.text = userNotification.description
            dateLabel.text = calculateTimeFrame(initialTime: userNotification?.dateTime ?? PostFormVC.dateFormatter.string(from: Date()))
        }
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Changing selection style
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    
    // MARK: - Methods
    func setupViews() {
        [imageIconView, mainStackView].forEach{addSubview($0)}
        sendSubviewToBack(contentView)
        imageIconView.withSize(CGSize(width: 18, height: 18))
        imageIconView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 30))
        mainStackView.anchor(top: imageIconView.topAnchor, leading: imageIconView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: -2, left: 10, bottom: 10, right: 30))
    }
   
    // MARK: - Selectors
    
}

// MARK: - ClientNotificationCellForChatBtn
class ClientNotificationCellForChatBtn: UITableViewCell {
    static let cellID = "ClientNotificationCellForChatBtnID"
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Notification Title"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Notification Description" //You can start a conversation with the post owner now
        lbl.numberOfLines = 0
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Feb 12"
        lbl.textColor = .systemGray2
        lbl.font = .systemFont(ofSize: 13)
        return lbl
    }()
    
    lazy var imageIconView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "bell.fill")
        return icon
    }()
    
    lazy var mainStackViewWithBtns: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descriptionLabel, startChatBtn, dateLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 5
        return sv
    }()
    
    lazy var startChatBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Start Chat", for: .normal)
        btn.withWidth(120)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.backgroundColor = .clear
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        
        btn.layer.borderColor = .init(srgbRed: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        btn.layer.borderWidth = 1
        btn.tintColor = .white
        return btn
    }()
        
    var userNotification: ClientNotificationModel! {
        didSet {
            descriptionLabel.text = userNotification.description
            dateLabel.text = calculateTimeFrame(initialTime: userNotification?.dateTime ?? PostFormVC.dateFormatter.string(from: Date()))
        }
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Changing selection style
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Methods
    func setupViews() {
        [imageIconView, mainStackViewWithBtns].forEach{addSubview($0)}
        sendSubviewToBack(contentView)
        imageIconView.withSize(CGSize(width: 18, height: 18))
        imageIconView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0))
        mainStackViewWithBtns.anchor(top: imageIconView.topAnchor, leading: imageIconView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: -2, left: 10, bottom: 10, right: 30))
    }
}
