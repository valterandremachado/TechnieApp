//
//  SubmitProposalCell.swift
//  Technie
//
//  Created by Valter A. Machado on 1/31/21.
//

import UIKit

class SubmitProposalCell: UITableViewCell {
    
    static let cellID = "SubmitProposalCellID"
    
    // MARK: - Properties
    lazy var txtLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Increase you chance to secure this job by writing why you should be selected for this job."
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var coverLetterTextField: UITextView = {
        let txtField = UITextView()
//        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
//        txtField.placeholder = "Write a cover letter"
//        txtField
        txtField.backgroundColor = .cyan
        txtField.clipsToBounds = true
//        txtField.borderStyle = .line
//        txtField.addBorder([.all], color: .red, thickness: 0.2)
        txtField.isEditable = true
        txtField.isScrollEnabled = false
        return txtField
    }()
 
    
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Changing selection style
        self.selectionStyle = .none

    }
    
    func setupViews() {
        [coverLetterTextField].forEach { contentView.addSubview($0)}
        coverLetterTextField.anchor(top: self.topAnchor, leading: contentView.leadingAnchor, bottom: self.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
